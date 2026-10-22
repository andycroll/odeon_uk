# Run separately after building: ODEON_PACKAGE=pkg/...gem bundle exec ruby test/package_test.rb
require "minitest/autorun"
require "rubygems/installer"
require "tmpdir"
require "fileutils"
require "open3"
require "base64"
require "json"

class PlatformPackageTest < Minitest::Test
  def setup
    @directory = Dir.mktmpdir("odeon-package-test")
    @spec = Gem::Installer.at(
      ENV.fetch("ODEON_PACKAGE"), install_dir: @directory, ignore_dependencies: true
    ).install
    @vendor = File.join(@spec.full_gem_path, "vendor", "curl-impersonate")
    @binary = File.join(@vendor, "bin", "curl-impersonate")
  end

  def teardown
    FileUtils.remove_entry(@directory)
  end

  def test_installs_runnable_executable_with_notices_and_provenance
    assert File.executable?(@binary)
    output, status = Open3.capture2(@binary, "--version")
    assert status.success?
    assert_includes output, "curl"
    assert File.file?(File.join(@vendor, "licenses", "LICENSE_CURL"))
    assert_includes File.read(File.join(@vendor, "SOURCE")), "2.2.3"
  end

  def test_acquires_token_with_gem_local_executable_and_no_curl_on_path
    payload = Base64.urlsafe_encode64(JSON.generate("exp" => Time.now.to_i + 3600), padding: false)
    token = "header.#{payload}.signature"
    data = { "api" => { "authToken" => token } }
    page = "<script>\nwindow.initialData = #{JSON.generate(data)};\n</script>\n200"
    # Substitute only the network response, not the installed package's path resolution.
    File.write(@binary, "#!#{RbConfig.ruby}\nSTDOUT.write(#{page.dump})\n")
    output, error, status = Open3.capture3(
      { "PATH" => @directory, "RUBYOPT" => nil, "BUNDLER_SETUP" => nil,
        "GEM_PATH" => Gem.path.join(File::PATH_SEPARATOR) }, RbConfig.ruby,
      "-I#{File.join(@spec.full_gem_path, 'lib')}", *cinebase_load_path, "-rodeon_uk",
      "-e", "print OdeonUk.acquire_token!"
    )
    assert status.success?, error
    assert_equal token, output
  end

  private

  # The package is installed without dependencies, so load the bundle's cinebase.
  def cinebase_load_path
    Gem.loaded_specs.fetch("cinebase").full_require_paths.map { |path| "-I#{path}" }
  end
end
