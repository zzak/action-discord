require "octokit"
require "uri"
require "cgi"
require "net/http"
require "json"

ACTOR = ENV["GITHUB_ACTOR"]
HOST = ENV["GITHUB_SERVER_URL"] || "https://github.com"
REPO = ENV["GITHUB_REPOSITORY"]
REPO_URL = "#{HOST}/#{REPO}"
RUN = ENV["GITHUB_RUN_ID"]
REF = ENV["GITHUB_REF_NAME"]
SHA = ENV["GITHUB_SHA"]
WORKFLOW = ENV["GITHUB_WORKFLOW"]
WEBHOOK = ENV["DISCORD_WEBHOOK"]

Octokit.configure do |conf|
  conf.api_endpoint = ENV.fetch("GITHUB_API_URL", "https://api.github.com")
  conf.auto_paginate = true
end

def github_token
  ENV.fetch("GITHUB_TOKEN") { raise "Missing $GITHUB_TOKEN!" }
end

@client = Octokit::Client.new(access_token: github_token)

path = @client.get("/repos/#{REPO}/actions/runs/#{RUN}").path
clean_path = URI.encode_www_form_component(path)
runs = @client.get("/repos/#{REPO}/actions/workflows/#{clean_path}/runs?branch=#{REF}&status=completed")
previous = runs.workflow_runs.select { |k,v| k.status == "completed" }.first.try(:conclusion)

jobs = @client.get("/repos/#{REPO}/actions/runs/#{RUN}/jobs")
status = jobs.jobs.any? { |job| job.conclusion == "failure"} ? "failure" : "success"

failed = jobs.jobs.each_with_object([]) do |job,arr|
  if job.conclusion == "failure"
    name = CGI.escapeHTML(job.name)
    arr << "- [#{name}](#{job.url})"
  end
end

title = "Skip"

if previous == "failure" and status == "success"
  title = "Fixed"
elsif previous == "failure" and status == "failure"
  title = "Still Failing"
elsif status == "failure"
  title = "Failed"
end

if status == "success"
  color = "65280"
else
  color = "16711680"
end

if title == "Skip"
  exit 0
end

resp = @client.get("/repos/#{REPO}/commits/#{SHA}")
message = CGI.escapeHTML(resp.commit.message)[0..100]

workflow = CGI.escapeHTML(WORKFLOW)[0..100]
sha = SHA[0,7]

def add_field(name, value, inline)
  return {
    name: name,
    value: value,
    inline: inline
  }
end

payload = {
  username: "GitHub",
  avatar_url: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
  embeds: [{
    color: color,
    title: "#{title}: #{REPO}@#{REF} `#{workflow}`",
    fields: [
      add_field("Message", message, false),
      add_field("Commit", "[#{sha}](#{REPO_URL}/commit/#{SHA})", true),
      add_field("Author", "[#{ACTOR}](#{HOST}/#{ACTOR})", true),
      add_field("Run", "[#{RUN}](#{REPO_URL}/actions/runs/#{RUN})", true),
      add_field("Repo", "[#{REPO}](#{REPO_URL})", false),
      add_field("Branch", "[#{REF}](#{REPO_URL}/tree/#{REF})", false)
    ]
  }]
}

if failed.count > 0
  payload[:embeds].first[:fields] << add_field("Failed Job(s)", failed.join("\n"), false)
end

uri = URI.parse(WEBHOOK)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

response = http.post(uri.path, payload.to_json, { "Content-Type" => "application/json" })

puts response.code
puts response.body