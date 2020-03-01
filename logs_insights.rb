#!/usr/bin/ruby

def now
    Time.now.utc
end

def hours(h)
    h * 60 * 60
end

def epoc(t)
    t.to_i
end

period_hours = ARGV[0].nil? ? (24 * 365) : ARGV[0].to_f
end_time = now
start_time = end_time - hours(period_hours)
STDERR.puts "From: #{start_time} to: #{end_time}"

log_group = ARGV[1].nil? ? "/aws/events/all" : ARGV[1]
STDERR.puts "Group: #{log_group}"

query = ARGV[2].nil? ? "fields @timestamp, @message | sort @timestamp desc | limit 20" : ARGV[2]
STDERR.puts "Query: #{query}"

command = "aws logs start-query --log-group-name '#{log_group}' --start-time #{epoc(start_time)} --end-time #{epoc(end_time)} --query-string \"#{query}\" --query 'queryId' --output text"
STDERR.puts "Command: #{command}"
query_id = `#{command}`.chomp

loop do
    sleep 1
    command2 = "aws logs get-query-results --query-id #{query_id} --query status --output text"
    STDERR.puts "Command: #{command2}"
    status = `#{command2}`.chomp
    STDERR.puts status
    break if status == "Complete"
end

command3 = "aws logs get-query-results --query-id #{query_id} --query 'results[*][?field == `@message`].value' --output text"
STDERR.puts "Command: #{command3}"
puts `#{command3}`

#Samples
#./logs_insights.rb | jq '.["detail-type"]'
