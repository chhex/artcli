module Artcli
  require "artifactory"
  require 'json'
  class Cli
    attr_reader :base_uri, :user, :passwd, :dry_run

    def initialize(base_uri, user, passwd, dry_run = false)
      @user = user
      @passwd = passwd
      puts @passwd
      @base_uri = "https://#{base_uri}"
      @dry_run = dry_run
    end
    def list_repositories(user_filter = '')
      client = Artifactory::Client.new(endpoint: @base_uri, username: @user, password: @passwd)
      local_repos = client.get("/api/repositories", {'type' => 'local'})
      filtered_repos = []
      local_repos.each do
      |repo|
        next unless (user_filter.empty? or repo['key'].include?("#{user_filter}"))
        filtered_repos << repo['key']
      end
      filtered_repos
    end
    def clean_repositories(repositories = [] , dry_run = false)
      if repositories.empty?
        puts "Nothing cleaned, no repositories"
      end
      puts "About to clean the following repositories #{repositories}"
      client = Artifactory::Client.new(endpoint: @base_uri, username: @user, password: @passwd)
      uris_to_delete = []
      repositories.each do
      |repo_name|
        storage = client.get("/api/storage/#{repo_name}")
        puts storage
        children = storage['children']
        children.each do
        |child|
          uris_to_delete << "#{@base_uri}/#{repo_name}#{child['uri']}"
        end
      end
      if uris_to_delete.empty?
        puts "Nothing to clean, filtered repositories empty"
        return
      end
      uris_to_delete.each do| uri |
        if !dry_run
          puts "#{uri} will be deleted"
          client.delete("#{uri}")
          puts "done"
        else
          puts "dry run: #{uri} would be deleted"
        end

      end
    end
  end

end