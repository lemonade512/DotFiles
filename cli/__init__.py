from common import Authentication, CommandInterface, user_input
from system_info import get_platform

if get_platform() == "darwin":
    import macos as CLI
else:
    import linux as CLI

CLI.user_input = user_input
