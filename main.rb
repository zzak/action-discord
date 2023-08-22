# frozen_string_literal: true

require "octokit"
require "uri"
require "cgi"
require "net/http"
require "json"

ACTOR = ENV["GITHUB_ACTOR"]
HOST = ENV["GITHUB_SERVER_URL"] || "https://github.com"
REPO = ENV["GITHUB_REPOSITORY"]
REPO_URL = "#{HOST}/#{REPO}".freeze
RUN = ENV["GITHUB_RUN_ID"]
REF = ENV["GITHUB_REF_NAME"]
SHA = ENV["GITHUB_SHA"]
WORKFLOW = ENV["GITHUB_WORKFLOW"]
JOB = ENV["ACTION_DISCORD_JOB_ID"]

Octokit.configure do |conf|
  conf.api_endpoint = ENV.fetch("GITHUB_API_URL", "https://api.github.com")
  conf.auto_paginate = true
end

def discord_webhook
  ENV.fetch("DISCORD_WEBHOOK") { raise "Missing $DISCORD_WEBHOOK!" }
end

def github_token
  ENV.fetch("GITHUB_TOKEN") { raise "Missing $GITHUB_TOKEN!" }
end

@client = Octokit::Client.new(access_token: github_token)
resp = @client.get("/repos/#{REPO}/commits/#{SHA}")
message = CGI.escapeHTML(resp.commit.message)[0..100]

workflow = CGI.escapeHTML(WORKFLOW)[0..100]
sha = SHA[0, 7]

def add_field(name, value, inline)
  {
    name:,
    value:,
    inline:
  }
end

payload = {
  username: "GitHub",
  avatar_url: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  embeds: [{
    color: "16711680",
    title: "Failed: #{REPO}@#{REF} `#{workflow}`",
    fields: [
      add_field("Message", message, false),
      add_field("Commit", "[#{sha}](#{REPO_URL}/commit/#{SHA})", true),
      add_field("Author", "[#{ACTOR}](#{HOST}/#{ACTOR})", true),
      add_field("Run", "[#{RUN}](#{REPO_URL}/actions/runs/#{RUN})", true),
      add_field("Repo", "[#{REPO}](#{REPO_URL})", false),
      add_field("Branch", "[#{REF}](#{REPO_URL}/tree/#{REF})", false),
      add_field("Job", JOB, false)
    ]
  }]
}

uri = URI.parse(discord_webhook)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

response = http.post(uri.path, payload.to_json, { "Content-Type" => "application/json" })

puts response.code
puts response.body
