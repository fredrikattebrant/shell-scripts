#!/usr/bin/bash
#
# Add the following lines to your cygwin .profile:
#
# launch/configure ssh-agent
#ssh-agent-check-and-run.sh
#eval $(cat $HOME/.ssh-agent-env)

SSH_AGENT_ENV_FILE=$HOME/.ssh-agent-env
SSH_AGENT_PID=""


launch_agent() {
    echo "Launching a new ssh-agent instance:"
    output="$(ssh-agent)"
    echo $output > $SSH_AGENT_ENV_FILE
    #echo ssh-agent environment:
    #echo $output
    eval $output
    echo "Login to the agent (PID=$SSH_AGENT_PID) - use the SSH (not Windows) password" 
    ssh-add
}

### main ###
#echo "Running $(basename $0):"
#echo ""

#echo Agent file: $SSH_AGENT_ENV_FILE
if [ -f $SSH_AGENT_ENV_FILE ]; then
    # load SSH AGENT environment
    #echo "Loading ssh-agent environment"
    eval $(cat $SSH_AGENT_ENV_FILE)
    #echo "Agent PID: $SSH_AGENT_PID"
fi

if [ -z "$SSH_AGENT_PID" ]; then
    #echo "No agent PID"
    launch_agent
else
    #echo "Got an agent PID: $SSH_AGENT_PID"
    # check if there is an actual agent running
    running=$(ps -ef | grep ssh-agent | grep $SSH_AGENT_PID)
    if [ -n "$running" ]; then
        echo "+++ ssh-agent already running with pid: $SSH_AGENT_PID"
    else
	launch_agent
    fi
fi


