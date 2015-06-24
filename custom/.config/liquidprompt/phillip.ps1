#######################################
# LIQUID PROMPT DEFAULT TEMPLATE FILE #
#######################################

# Available features:
# LP_BATT battery
# LP_LOAD load
# LP_JOBS screen sessions/running jobs/suspended jobs
# LP_USER user
# LP_HOST hostname
# LP_PERM a colon ":"
# LP_PWD current working directory
# LP_VENV Python virtual environment
# LP_PROXY HTTP proxy
# LP_VCS the content of the current repository
# LP_ERR last error code
# LP_MARK prompt mark
# LP_TIME current time
# LP_RUNTIME runtime of last command
# LP_MARK_PREFIX user-defined prompt mark prefix (helpful if you want 2-line prompts)
# LP_PS1_PREFIX user-defined general-purpose prefix (default set a generic prompt as the window title)
# LP_PS1_POSTFIX user-defined general-purpose postfix
# LP_BRACKET_OPEN open bracket
# LP_BRACKET_CLOSE close bracket

# Add prefix
LP_PS1="${LP_PS1_PREFIX}"

# Add Virtual env and battery
LP_PS1=$LP_PS1"${LP_TEMP}${LP_BATT}${LP_JOBS}${LP_VENV}"

# Add user, host, and current working directory
LP_PS1=$LP_PS1"${LP_BRACKET_OPEN} ${LP_USER}${LP_HOST} ${LP_PWD} ${LP_BRACKET_CLOSE}"
LP_PS1=$LP_PS1"${LP_RUNTIME}"

# Add version control
LP_PS1=$LP_PS1"${LP_VCS}"

# Add prompt mark
LP_PS1=$LP_PS1"\n${LP_MARK}"

LP_PS1=$LP_PS1"${LP_PS1_POSTFIX}"

#LP_PS1="${LP_PS1}[ ${LP_USER}${LP_HOST}:${BLUE}$(pwd)${NO_COL} ]${LP_GIT}${LP_VCS}${BOLD_RED}${LP_PS1_POSTFIX}${NO_COL}"


