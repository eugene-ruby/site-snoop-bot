every 10.minutes do
  rake "snapshots:check_all", output: "log/cron.log"
end
