# aliases
alias k="kubectl"
alias kpg="kubectl get pods | grep"
alias ksg="kubectl get service | grep"
alias k_get_pods_sort_by_time="k get pods --sort-by=.metadata.creationTimestamp"

# Select a running pod by project name. Sets RUNNING_POD and LEFT_ARGS for callers.
# Usage: getpod -p <project> [-n namespace] [-K context] [-R] [-s src] [-d dst] [-v]
function getpod {
  local random=true verbose=false namespace=default project="" src="" dst="" pod_index
  OPTIND=1

  while getopts ":hvs:d:K:Rp:n:" opt; do
    case $opt in
      R) random=false         ;;
      s) src=$OPTARG          ;;
      d) dst=$OPTARG          ;;
      n) namespace=$OPTARG    ;;
      p) project=$OPTARG      ;;
      K) KCONTEXT=$OPTARG     ;;
      v) verbose=true         ;;
      h) echo "Usage: getpod -p PROJECT [-n NAMESPACE] [-K CONTEXT] [-R] [-s SRC] [-d DST] [-v]"; return 0 ;;
      *) echo "Unknown option: -$OPTARG"; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -z "$project" ]]; then
    echo $fg[red]"Error: -p PROJECT is required"$reset_color
    return 1
  fi

  # Export state for callers (kexec, kcp)
  NAMESPACE=$namespace SRC=$src DST=$dst VERBOSE=$verbose
  RUNNING_POD="" LEFT_ARGS="$@"

  local -a running_pods
  while true; do
    [[ $verbose == true ]] && echo "kubectl -n $namespace get pods | grep $project"
    local all_pods=$(kubectl -n $namespace get pods | grep "$project")

    if [[ -z "$all_pods" ]]; then
      echo $fg[red]"No pods found for $project"$reset_color
      return 1
    fi

    echo $fg[green]"All Pods:"$reset_color
    echo "$all_pods"

    running_pods=("${(@f)$(echo "$all_pods" | awk '/Running/ && $2 ~ /[1-9]\/[0-9]/ {print $1}')}")
    running_pods=(${running_pods:#})  # remove empty entries

    local total=$(echo "$all_pods" | wc -l | tr -d ' ')
    if [[ $total -ne ${#running_pods[@]} ]]; then
      echo $fg[red]'Pods not ready, retrying...'$reset_color
      sleep 2
      continue
    fi
    if [[ ${#running_pods[@]} -eq 0 ]]; then
      echo $fg[red]"No running pods for $project"$reset_color
      return 1
    fi
    break
  done

  # Select pod: random, single, or interactive
  if [[ ${#running_pods[@]} -eq 1 || $random == true ]]; then
    pod_index=$(($RANDOM % ${#running_pods[@]} + 1))
  else
    echo $fg[green]'Running Pods:'$reset_color
    local i
    for i in {1..${#running_pods[@]}}; do
      echo "[$i] $running_pods[$i]"
    done
    echo $fg[green]'Select pod:'$reset_color
    while true; do
      read pod_index
      [[ $pod_index -gt 0 && $pod_index -le ${#running_pods[@]} ]] && break
      echo 'Invalid option...'
    done
  fi

  RUNNING_POD=$running_pods[$pod_index]
}

function kexec {
  getpod $@ || return 1
  echo "kubectl -it -n $NAMESPACE exec $RUNNING_POD -- /bin/sh -c $LEFT_ARGS"
  kubectl -it -n $NAMESPACE exec $RUNNING_POD -- /bin/sh -c $LEFT_ARGS
}

function kcp {
  getpod $@ || return 1
  [[ $VERBOSE == true ]] && echo "Running: $fg[green]kubectl -n $NAMESPACE cp $RUNNING_POD:$SRC $DST$reset_color"
  kubectl -n $NAMESPACE cp $RUNNING_POD:$SRC $DST
}

for zxfunc in klogs ktail git_search_commit kdown
do
  $zxfunc() {
    ~/.lingti/zsh/zx/$0.mjs "$@"
  }
done
function k_delete_evicted {
  k delete pod `k get pods | grep Evicted | awk '{print $1}'`
}
function k_get_instance {
  k get pods -o jsonpath="{.items[*].metadata.labels['app\.kubernetes\.io\/instance']}" | tr " " "\n" | uniq
}
function kubectl() {
  DEBUG=false
  finalopts=()
  while [[ $@ != "" ]] do
    case $1 in
      --context=*)
        KCONTEXT="${i#*=}"
        shift
        ;;
      --debug)
        DEBUG=true
        shift
        ;;
      --)
        finalopts+=("$@")
        break
        ;;
      *)
        finalopts+=($1)
        shift
        ;;
    esac
  done
  [[ $DEBUG == "true" ]] && echo "kubectl --kubeconfig=$HOME/.kube/${KCONTEXT}_config $finalopts"
  command kubectl --kubeconfig=$HOME/.kube/${KCONTEXT}_config $finalopts
}
function k_force_delete_pod () {
  k delete pod $1 --grace-period=0 --force
}
function k_get_containers_of_pod {
  k get pods $1 -o jsonpath='{.spec.containers[*].name}*'
}
function set_k8s_context_core {
  C=$1
  if [[ "$C" == "" ]]; then
    echo "Select your context:"
    ls ~/.kube/*_config | xargs -n 1 basename | sed s/_config//g
    read C
  fi
  export KCONTEXT=$C
}

function helm() {
  DEBUG=false
  finalopts=()
  while [[ $@ != "" ]] do
    case $1 in
      --context=*)
        KCONTEXT="${i#*=}"
        shift
        ;;
      --debug)
        DEBUG=true
        finalopts+=($1)
        shift
        ;;
      *)
        finalopts+=($1)
        shift
        ;;
    esac
  done
  [[ $DEBUG == "true" ]] && echo "helm $finalopts --kubeconfig=$HOME/.kube/${KCONTEXT}_config"
  command helm $finalopts --kubeconfig=$HOME/.kube/${KCONTEXT}_config
}
