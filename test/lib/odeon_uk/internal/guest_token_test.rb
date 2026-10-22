require_relative '../../../test_helper'
require 'base64'
require 'tmpdir'

class OdeonUk::Internal::GuestTokenTest < Minitest::Test
  def setup
    @directory = Dir.mktmpdir('odeon-guest-token')
  end

  def teardown
    FileUtils.remove_entry(@directory)
    OdeonUk.token = nil
  end

  def test_fetch_returns_token_from_page_data
    token = token_expiring_at(Time.now + 3600)
    curl = fake_curl("#{page_with(token)}\n200")

    assert_equal token, guest_token(curl).fetch
  end

  def test_fetch_rejects_expired_token
    curl = fake_curl("#{page_with(token_expiring_at(Time.now - 60))}\n200")

    assert_raises(OdeonUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_fetch_rejects_page_without_page_data
    curl = fake_curl("<html></html>\n200")

    assert_raises(OdeonUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_fetch_rejects_redirect_to_queue
    curl = fake_curl("\n302")

    assert_raises(OdeonUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_fetch_rejects_failed_command
    curl = fake_curl('', exit_status: 7)

    assert_raises(OdeonUk::AuthenticationError) { guest_token(curl).fetch }
  end

  def test_fetch_explains_missing_executable
    error = assert_raises(OdeonUk::AuthenticationError) do
      guest_token(File.join(@directory, 'missing')).fetch
    end

    assert_match(/curl-impersonate/, error.message)
  end

  def test_acquire_token_sets_token
    token = token_expiring_at(Time.now + 3600)

    OdeonUk.acquire_token!(curl: fake_curl("#{page_with(token)}\n200"))

    assert_equal token, OdeonUk.token
  end

  private

  def guest_token(curl)
    OdeonUk::Internal::GuestToken.new(curl: curl)
  end

  def token_expiring_at(time)
    payload = Base64.urlsafe_encode64(JSON.generate('exp' => time.to_i), padding: false)
    "header.#{payload}.signature"
  end

  def page_with(token)
    data = { 'api' => { 'apiUrl' => 'https://vwc.odeon.co.uk/WSVistaWebClient', 'authToken' => token } }
    "<script>\n  window.initialData = #{JSON.generate(data)};\n  window.pageData = [];\n</script>"
  end

  def fake_curl(output, exit_status: 0)
    path = File.join(@directory, 'curl-impersonate')
    File.write(path, "#!#{RbConfig.ruby}\nSTDOUT.write(#{output.dump})\nexit #{exit_status}\n")
    File.chmod(0o755, path)
    path
  end
end
