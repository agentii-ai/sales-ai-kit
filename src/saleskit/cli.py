#!/usr/bin/env python3
"""Sales-AI-Kit CLI implementation.

Provides the `sales` executable for managing Sales-AI-Kit projects with
collision-free namespace isolation.
"""

import argparse
import shutil
import sys
from importlib import resources
from pathlib import Path

# ASCII Art Banner
ASCII_BANNER = r"""
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║    ███████╗ █████╗ ██╗     ███████╗███████╗              ║
║    ██╔════╝██╔══██╗██║     ██╔════╝██╔════╝              ║
║    ███████╗███████║██║     █████╗  ███████╗              ║
║    ╚════██║██╔══██║██║     ██╔══╝  ╚════██║              ║
║    ███████║██║  ██║███████╗███████╗███████║              ║
║    ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝              ║
║                                                           ║
║               █████╗ ██╗      ██╗  ██╗██╗████████╗       ║
║              ██╔══██╗██║      ██║ ██╔╝██║╚══██╔══╝       ║
║              ███████║██║█████╗█████╔╝ ██║   ██║          ║
║              ██╔══██║██║╚════╝██╔═██╗ ██║   ██║          ║
║              ██║  ██║██║      ██║  ██╗██║   ██║          ║
║              ╚═╝  ╚═╝╚═╝      ╚═╝  ╚═╝╚═╝   ╚═╝          ║
║                                                           ║
║         Spec-driven development for Sales & GTM          ║
║                      Version: 0.1.0                       ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"""

# Supported agents with their directory configurations
AGENT_CONFIGS = {
    "claude": {"dir": ".claude", "subdir": "commands", "ext": ".md"},
    "cursor-agent": {"dir": ".cursor", "subdir": "commands", "ext": ".md"},
    "windsurf": {"dir": ".windsurf", "subdir": "workflows", "ext": ".md"},
    "gemini": {"dir": ".gemini", "subdir": "commands", "ext": ".toml"},
    "copilot": {"dir": ".github", "subdir": "agents", "ext": ".agent.md", "extra_dir": ".github/prompts"},
    "qoder": {"dir": ".qoder", "subdir": "commands", "ext": ".md"},
    "qwen": {"dir": ".qwen", "subdir": "commands", "ext": ".md"},
    "opencode": {"dir": ".opencode", "subdir": "commands", "ext": ".md"},
    "codex": {"dir": ".codex", "subdir": "commands", "ext": ".md"},
    "kilocode": {"dir": ".kilocode", "subdir": "commands", "ext": ".md"},
    "auggie": {"dir": ".auggie", "subdir": "commands", "ext": ".md"},
    "roo": {"dir": ".roo", "subdir": "commands", "ext": ".md"},
    "codebuddy": {"dir": ".codebuddy", "subdir": "commands", "ext": ".md"},
    "amp": {"dir": ".amp", "subdir": "commands", "ext": ".md"},
    "shai": {"dir": ".shai", "subdir": "commands", "ext": ".md"},
    "q": {"dir": ".q", "subdir": "commands", "ext": ".md"},
    "bob": {"dir": ".bob", "subdir": "commands", "ext": ".md"},
}

SCRIPT_VARIANTS = {
    "sh": {"name": "Bash (Linux/Mac)", "dir": "bash"},
    "ps1": {"name": "PowerShell (Windows)", "dir": "powershell"},
}


def print_namespace_info():
    """Display resolved kit namespace values for verification."""
    print("Sales-AI-Kit Namespace Configuration:")
    print("=" * 50)
    print(f"  CLI executable:           sales")
    print(f"  Distribution name:        sales-cli")
    print(f"  Module namespace:         saleskit")
    print(f"  Kit folder (generated):   .saleskit/")
    print(f"  Slash command prefix:     saleskit.*")
    print(f"  Workflow commands:")
    print(f"    - /saleskit.constitution")
    print(f"    - /saleskit.specify")
    print(f"    - /saleskit.clarify")
    print(f"    - /saleskit.plan")
    print(f"    - /saleskit.tasks")
    print(f"    - /saleskit.implement")
    print("=" * 50)
    print("\nNo collisions with other *-kit variants.")
    print("Safe to install alongside Spec-Kit, Blog-Kit, PMF-Kit, etc.")


def prompt_agent_selection() -> str:
    """Interactive prompt for agent selection."""
    print("\n" + "=" * 60)
    print("  SELECT YOUR AI CODING AGENT")
    print("=" * 60)
    print("\nSupported AI Agents:")

    agents_list = list(AGENT_CONFIGS.keys())
    for idx, agent in enumerate(agents_list, 1):
        # Format agent name nicely
        agent_display = agent.replace("-", " ").title()
        print(f"  [{idx:2d}] {agent_display}")

    print("\n" + "=" * 60)

    while True:
        try:
            choice = input("\nEnter your choice (1-{}): ".format(len(agents_list))).strip()
            if not choice:
                print("  Error: Please enter a number")
                continue

            choice_idx = int(choice) - 1
            if 0 <= choice_idx < len(agents_list):
                selected_agent = agents_list[choice_idx]
                agent_display = selected_agent.replace("-", " ").title()
                print(f"\n✓ Selected: {agent_display}")
                return selected_agent
            else:
                print(f"  Error: Please enter a number between 1 and {len(agents_list)}")
        except ValueError:
            print("  Error: Please enter a valid number")
        except KeyboardInterrupt:
            print("\n\nCancelled by user.")
            sys.exit(130)


def prompt_script_variant() -> str:
    """Interactive prompt for script variant selection."""
    print("\n" + "=" * 60)
    print("  SELECT YOUR SCRIPT TYPE")
    print("=" * 60)
    print("\nAvailable Script Types:")

    variants_list = list(SCRIPT_VARIANTS.keys())
    for idx, variant in enumerate(variants_list, 1):
        variant_name = SCRIPT_VARIANTS[variant]["name"]
        print(f"  [{idx}] {variant_name}")

    print("\n" + "=" * 60)

    while True:
        try:
            choice = input("\nEnter your choice (1-{}): ".format(len(variants_list))).strip()
            if not choice:
                print("  Error: Please enter a number")
                continue

            choice_idx = int(choice) - 1
            if 0 <= choice_idx < len(variants_list):
                selected_variant = variants_list[choice_idx]
                variant_name = SCRIPT_VARIANTS[selected_variant]["name"]
                print(f"\n✓ Selected: {variant_name}")
                return selected_variant
            else:
                print(f"  Error: Please enter a number between 1 and {len(variants_list)}")
        except ValueError:
            print("  Error: Please enter a valid number")
        except KeyboardInterrupt:
            print("\n\nCancelled by user.")
            sys.exit(130)


def cmd_namespace(args):
    """Display namespace self-check information."""
    print_namespace_info()
    return 0


def cmd_init(args):
    """Initialize a new Sales-AI-Kit project."""
    # Show ASCII banner
    print(ASCII_BANNER)

    target_dir = Path(args.directory or ".").expanduser().resolve()

    print("Sales-AI-Kit Project Initialization")
    print(f"Target directory: {target_dir}\n")

    target_dir.mkdir(parents=True, exist_ok=True)

    dest_saleskit_dir = target_dir / ".saleskit"
    if dest_saleskit_dir.exists():
        print(f"\nError: {dest_saleskit_dir} already exists. Refusing to overwrite.", file=sys.stderr)
        return 1

    # Interactive agent selection if not specified via --ai flag
    if args.ai:
        agent = args.ai
        print(f"Using agent specified via --ai flag: {agent}")
    else:
        agent = prompt_agent_selection()

    # Interactive script variant selection if not specified via --script flag
    if args.script:
        script_variant = args.script
        print(f"Using script variant specified via --script flag: {SCRIPT_VARIANTS[script_variant]['name']}")
    else:
        script_variant = prompt_script_variant()

    # Now fetch the template source
    src_saleskit_dir = _find_saleskit_template_dir()
    if src_saleskit_dir is None:
        print("\nError: Could not locate source .saleskit/ templates.", file=sys.stderr)
        print("This usually means you are running from an installed wheel that did not include templates.")
        print("Try running from a source checkout or editable install.")
        return 1

    # Copy .saleskit/ directory structure
    shutil.copytree(src_saleskit_dir, dest_saleskit_dir)

    # Copy appropriate script variant
    scripts_dest = dest_saleskit_dir / "scripts"
    if script_variant == "sh":
        # Keep bash scripts, remove powershell if it exists
        ps_dir = scripts_dest / "powershell"
        if ps_dir.exists():
            shutil.rmtree(ps_dir)
    elif script_variant == "ps1":
        # Keep powershell scripts, remove bash if it exists
        bash_dir = scripts_dest / "bash"
        if bash_dir.exists():
            shutil.rmtree(bash_dir)

    print("\n" + "=" * 60)
    print("✅ Created .saleskit/ (constitution + templates)")
    print(f"  - {dest_saleskit_dir / 'memory' / 'constitution.md'}")
    print(f"  - {dest_saleskit_dir / 'templates'}")
    print(f"  - {dest_saleskit_dir / 'scripts' / SCRIPT_VARIANTS[script_variant]['dir']}")

    # Generate agent-specific files
    try:
        _generate_agent_files(target_dir=target_dir, agent=agent)
    except Exception as e:
        print(f"\nError while generating agent files: {e}", file=sys.stderr)
        return 1

    print("\n" + "=" * 60)
    print("🎉 SETUP COMPLETE!")
    print("=" * 60)
    print("\nNext steps:")
    print("  - Start a feature: use your agent with /saleskit.specify")
    print("  - Inspect templates under .saleskit/")
    print("  - Review your constitution: .saleskit/memory/constitution.md")
    print("\n" + "=" * 60)

    return 0


def _find_saleskit_template_dir() -> Path | None:
    """Locate the repository's `.saleskit/` folder.

    This is primarily intended for editable/source usage. We walk up from this file
    until we find a sibling `.saleskit/` directory.
    """
    try:
        candidate = resources.files("saleskit").joinpath(".saleskit")
        with resources.as_file(candidate) as candidate_path:
            if candidate_path.is_dir():
                return candidate_path
    except Exception:
        pass

    here = Path(__file__).resolve()
    for parent in here.parents:
        candidate = parent / ".saleskit"
        if candidate.is_dir():
            return candidate
    return None


def _generate_agent_files(target_dir: Path, agent: str) -> None:
    """Generate agent-specific command/workflow files."""
    commands_src_dir = target_dir / ".saleskit" / "templates" / "commands"
    if not commands_src_dir.is_dir():
        raise FileNotFoundError(f"Missing command templates directory: {commands_src_dir}")

    if agent not in AGENT_CONFIGS:
        raise ValueError(f"Unsupported agent: {agent}")

    agent_config = AGENT_CONFIGS[agent]
    dest_dir = target_dir / agent_config["dir"] / agent_config["subdir"]
    dest_dir.mkdir(parents=True, exist_ok=True)

    # Handle special case for Copilot which has additional directories
    if "extra_dir" in agent_config:
        extra_dir = target_dir / agent_config["extra_dir"]
        extra_dir.mkdir(parents=True, exist_ok=True)

    copied = 0
    for template_path in sorted(commands_src_dir.glob("saleskit.*.md")):
        # Determine output file extension based on agent
        ext = agent_config["ext"]
        target_filename = template_path.stem + ext

        target_path = dest_dir / target_filename

        # For Gemini TOML format, we'd need to convert markdown to TOML
        # For now, just copy the markdown with appropriate extension
        shutil.copy2(template_path, target_path)
        copied += 1

    agent_dir_display = f"{agent_config['dir']}/{agent_config['subdir']}"
    print(f"\n✅ Generated {copied} agent command files")
    print(f"  - Agent: {agent.replace('-', ' ').title()}")
    print(f"  - Destination: {agent_dir_display}")

def cmd_version(args):
    """Display Sales-AI-Kit version."""
    from saleskit import __version__
    print(f"Sales-AI-Kit version {__version__}")
    print(f"Distribution: sales-cli")
    return 0


def create_parser():
    """Create the argument parser for the sales CLI."""
    parser = argparse.ArgumentParser(
        prog="sales",
        description="Sales-AI-Kit: Spec-driven development for AI/LLM SaaS sales and marketing",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  sales namespace              Show namespace configuration (collision check)
  sales init                   Initialize a new Sales-AI-Kit project
  sales init --ai claude       Initialize with Claude Code workflows
  sales version                Show Sales-AI-Kit version

Workflow Commands (use via AI agent):
  /saleskit.constitution       Create or update project constitution
  /saleskit.specify            Specify a new feature
  /saleskit.clarify            Clarify underspecified areas in spec
  /saleskit.plan               Generate implementation plan
  /saleskit.tasks              Generate task breakdown
  /saleskit.implement          Execute implementation

For more information, see the Sales-AI-Kit documentation.
        """
    )

    parser.add_argument(
        "--version",
        action="store_true",
        help="show Sales-AI-Kit version and exit"
    )

    subparsers = parser.add_subparsers(dest="command", help="available commands")

    # namespace command
    namespace_parser = subparsers.add_parser(
        "namespace",
        help="Display namespace configuration (multi-kit collision check)"
    )
    namespace_parser.set_defaults(func=cmd_namespace)

    # init command
    init_parser = subparsers.add_parser(
        "init",
        help="Initialize a new Sales-AI-Kit project"
    )
    init_parser.add_argument(
        "directory",
        nargs="?",
        help="target directory (default: current directory)"
    )
    init_parser.add_argument(
        "--ai",
        choices=list(AGENT_CONFIGS.keys()),
        help="target AI agent for workflow generation (if not specified, will prompt interactively)"
    )
    init_parser.add_argument(
        "--script",
        choices=list(SCRIPT_VARIANTS.keys()),
        help="script variant: sh (bash) or ps1 (powershell) (if not specified, will prompt interactively)"
    )
    init_parser.set_defaults(func=cmd_init)

    # version command
    version_parser = subparsers.add_parser(
        "version",
        help="Show Sales-AI-Kit version"
    )
    version_parser.set_defaults(func=cmd_version)

    return parser


def main():
    """Main entry point for the sales CLI."""
    parser = create_parser()
    args = parser.parse_args()

    # Handle --version flag at top level
    if args.version:
        return cmd_version(args)

    # If no command specified, show help
    if not hasattr(args, "func"):
        parser.print_help()
        return 0

    # Execute the selected command
    try:
        return args.func(args)
    except KeyboardInterrupt:
        print("\n\nInterrupted by user.", file=sys.stderr)
        return 130
    except Exception as e:
        print(f"\nError: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
