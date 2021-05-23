from typing import Dict, Any

class Configuration:

    def __init__(self, option_under_investigation: str,
                 configuration: Dict[str, str],
                 config_file : str):
        self.option_under_investigation = option_under_investigation
        self.configuration = configuration
        self.config_file = config_file

    def __eq__(self, o1: Any):
        return isinstance(o1, Configuration) and\
            self.option_under_investigation == o1.option_under_investigation and\
            self.configuration == o1.configuration and\
            self.config_file == o1.config_file

    def __hash__(self):
        return hash((self.option_under_investigation, self.configuration, self.config_file))

    
