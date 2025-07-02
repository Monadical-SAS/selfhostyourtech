#!/usr/bin/env python3
import yaml
import os
import subprocess
import sys

SELFHOSTYOURTECH_ROOT = os.environ.get('SELFHOSTYOURTECH_ROOT', '/opt/selfhostyourtech')


# Paths to configuration files
APPS_FILE = f"{SELFHOSTYOURTECH_ROOT}/etc/apps-enabled.yaml"
CONFIG_FILE = f"{SELFHOSTYOURTECH_ROOT}/apps/homer/etc/config.yaml"
SERVICES_FILE = f"{SELFHOSTYOURTECH_ROOT}/apps/homer/etc/services.yaml"
HOMER_CONFIG = f"{SELFHOSTYOURTECH_ROOT}/apps/homer/config/config.yml"
SHARED_CONFIG = f"{SELFHOSTYOURTECH_ROOT}/etc/config.yaml"

def load_yaml(file_path):
    """Load YAML file"""
    try:
        with open(file_path, 'r') as file:
            return yaml.safe_load(file)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return None


def load_txt(file_path):
    """Load text file and return its contents"""
    try:
        with open(file_path, 'r') as file:
            return file.read()
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return None


def generate_homer_config():
    """Generate Homer configuration based on enabled apps"""
    # Load configurations
    apps_config = load_yaml(APPS_FILE)
    global_config = load_yaml(CONFIG_FILE)
    services_config = load_yaml(SERVICES_FILE)
    shared_config = load_yaml(SHARED_CONFIG)
    base_domain = shared_config['base_domain']
    environment = shared_config['environment']

    http_scheme = "https"
    if environment == "dev":
        http_scheme = "http"

    if not apps_config or not global_config or not services_config:
        print("Failed to load configuration files")
        return False
    
    # Extract domain and enabled apps
    domain = base_domain
    enabled_apps = apps_config.get('apps', [])
    services_data = services_config.get('services', {})
    categories_data = services_config.get('categories', {})
    
    # Start building Homer configuration
    homer_config = {
        "title": global_config.get('title', "SelfHosted Kit"),
        "subtitle": global_config.get('subtitle', "Self-hosted business infrastructure"),
        "logo": global_config.get('logo', "logo.png"),
        "header": global_config.get('header', True),
        "footer": global_config.get('footer', '<p>Created with <span class="has-text-danger">❤️</span> by <a href="https://monadical.com">Monadical</a></p>'),
        "theme": global_config.get('theme', "walkxcode"),
        "colors": global_config.get('colors', {
            "light": {
                "highlight-primary": "#7c3aed",
                "highlight-secondary": "#9333ea",
                "highlight-hover": "#6d28d9",
                "background": "#1f2937",
                "card-background": "#111827",
                "text": "#ffffff",
                "text-header": "#fafafa",
                "text-title": "#ffffff",
                "text-subtitle": "#f5f5f5",
                "card-shadow": "rgba(0, 0, 0, 0.4)",
                "link": "#7c3aed",
                "link-hover": "#6d28d9"
            }
        }),
        "services": [],
        "links": global_config.get('links', [
            {
                "name": "Documentation",
                "icon": "fas fa-book",
                "url": f"{http_scheme}://docs.{domain}",
                "target": "_blank"
            },
            {
                "name": "GitHub",
                "icon": "fab fa-github",
                "url": "https://github.com/Monadical-SAS/selfhostyourtech",
                "target": "_blank"
            }
        ])
    }
    
    # Organize enabled apps by category
    apps_by_category = {}
    for app_name in enabled_apps:
        if app_name in services_data:
            app_info = services_data[app_name]
            category = app_info.get("category")
            
            if not category:
                continue
                
            if category not in apps_by_category:
                apps_by_category[category] = []
            
            subdomain = app_name

            alias = app_info.get("alias", "")
            if alias != "":
                subdomain = alias
                
            # Create app entry
            app_entry = {
                "name": app_info.get("name", app_name.capitalize()),
                "logo": app_info.get("logo", ""),
                "subtitle": app_info.get("subtitle", ""),
                "url": f"{http_scheme}://{subdomain}.{domain}",
                "target": "_blank"
            }
            
            # Add type if specified
            if app_info.get("type"):
                app_entry["type"] = app_info["type"]
                
            apps_by_category[category].append(app_entry)
    
    # Create service categories
    for category, apps in apps_by_category.items():
        if apps:  # Only add categories that have enabled apps
            icon = "fas fa-circle"  # Default icon
            if category in categories_data and "icon" in categories_data[category]:
                icon = categories_data[category]["icon"]
                
            service_category = {
                "name": category,
                "icon": icon,
                "items": apps
            }
            homer_config["services"].append(service_category)
    
    # Save the generated configuration
    try:
        with open(HOMER_CONFIG, 'w') as file:
            yaml.dump(homer_config, file, sort_keys=False)
        return True
    except Exception as e:
        print(f"Error saving Homer configuration: {e}")
        return False


if __name__ == "__main__":
    print("Generating Homer configuration...")
    if generate_homer_config():
        print("Configuration generated successfully")
    else:
        print("Failed to generate configuration")
