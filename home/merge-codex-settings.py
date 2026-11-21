import json
import sys
from pathlib import Path
from tempfile import NamedTemporaryFile

import tomlkit


def main(config_path, settings_path):
    config_path = config_path.resolve()
    original = config_path.read_text() if config_path.exists() else ""
    config = tomlkit.parse(original)
    settings = json.loads(settings_path.read_text())

    for table_name, entries in settings.items():
        table = config.setdefault(table_name, tomlkit.table())
        for key, value in entries.items():
            if table.get(key) != value:
                table[key] = value

    updated = tomlkit.dumps(config)
    if updated == original:
        return

    config_path.parent.mkdir(parents=True, exist_ok=True)
    with NamedTemporaryFile(dir=config_path.parent, mode="w", delete=False) as output:
        temporary = Path(output.name)
        try:
            output.write(updated)
            output.close()
            temporary.replace(config_path)
        finally:
            temporary.unlink(missing_ok=True)


if __name__ == "__main__":
    main(*(Path(arg) for arg in sys.argv[1:]))
