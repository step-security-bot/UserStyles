import toml
import os

def generate_toml_file(filename="example.toml"):
    """
    Generates a sample TOML file with various data types.

    Args:
        filename (str, optional): The name of the TOML file to create.
                                   Defaults to "example.toml".
    """

    data = {
        "title": "TOML Example",
        "owner": {
            "name": "Nick2bad4u",
            "dob": "1990-01-01",
            "organization": "GitHub",
        },
        "database": {
            "server": "192.168.1.1",
            "ports": [8000, 8001, 8002],
            "connection_max": 5000,
            "enabled": True,
        },
        "servers": {
            "alpha": {
                "ip": "10.0.0.1",
                "dc": "eqdc10",
            },
            "beta": {
                "ip": "10.0.0.2",
                "dc": "eqdc10",
            },
        },
        "packages": [
            {"name": "requests", "version": "2.28.1"},
            {"name": "numpy", "version": "1.23.5"},
        ],
        "array_of_tables": [
            {"name": "table1", "value": 1},
            {"name": "table2", "value": 2},
        ],
    }

    try:
        with open(filename, "w") as toml_file:
            toml.dump(data, toml_file)
        print(f"TOML file '{filename}' generated successfully.")
    except Exception as e:
        print(f"Error generating TOML file: {e}")


if __name__ == "__main__":
    generate_toml_file()
