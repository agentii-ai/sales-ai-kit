#!/usr/bin/env python3
"""Sales-AI-Kit CLI implementation.

Provides the `sales` executable for managing Sales-AI-Kit projects with
collision-free namespace isolation.
"""

import argparse
import sys
import shutil
from pathlib import Path


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


def cmd_namespace(args):
    """Display namespace self-check information."""
    print_namespace_info()
    return 0


def cmd_init(args):
    """Initialize a new Sales-AI-Kit project."""
    target_dir = Path(args.directory or ".").expanduser().resolve()

    print("Sales-AI-Kit Project Initialization")
    print(f"Target directory: {target_dir}")

    target_dir.mkdir(parents=True, exist_ok=True)

    dest_saleskit_dir = target_dir / ".saleskit"
    if dest_saleskit_dir.exists():
        print(f"\nError: {dest_saleskit_dir} already exists. Refusing to overwrite.", file=sys.stderr)
        return 1

    src_saleskit_dir = _find_saleskit_template_dir()
    if src_saleskit_dir is None:
        print("\nError: Could not locate source .saleskit/ templates.", file=sys.stderr)
        print("This usually means you are running from an installed wheel that did not include templates.")
        print("Try running from a source checkout or editable install.")
        return 1

    shutil.copytree(src_saleskit_dir, dest_saleskit_dir)

    print("\n✅ Created .saleskit/ (constitution + templates)")
    print(f"  - {dest_saleskit_dir / 'memory' / 'constitution.md'}")
    print(f"  - {dest_saleskit_dir / 'templates'}")

    if args.ai:
        try:
            _generate_agent_files(target_dir=target_dir, agent=args.ai)
        except Exception as e:
            print(f"\nError while generating agent files: {e}", file=sys.stderr)
            return 1

    print("\nNext steps:")
    print("  - Start a feature: use your agent with /saleskit.specify")
    print("  - Inspect templates under .saleskit/")

    return 0


def _find_saleskit_template_dir() -> Path | None:
    """Locate the repository's `.saleskit/` folder.

    This is primarily intended for editable/source usage. We walk up from this file
    until we find a sibling `.saleskit/` directory.
    """
    here = Path(__file__).resolve()
    for parent in here.parents:
        candidate = parent / ".saleskit"
        if candidate.is_dir():
            return candidate
    return None


def _generate_agent_files(target_dir: Path, agent: str) -> None:
    commands_src_dir = target_dir / ".saleskit" / "templates" / "commands"
    if not commands_src_dir.is_dir():
        raise FileNotFoundError(f"Missing command templates directory: {commands_src_dir}")

    if agent == "claude":
        dest_dir = target_dir / ".claude" / "commands"
    elif agent == "windsurf":
        dest_dir = target_dir / ".windsurf" / "workflows"
    elif agent == "cursor":
        dest_dir = target_dir / ".cursor" / "commands"
    else:
        raise ValueError(f"Unsupported agent: {agent}")

    dest_dir.mkdir(parents=True, exist_ok=True)

    copied = 0
    for template_path in sorted(commands_src_dir.glob("*.md")):
        shutil.copy2(template_path, dest_dir / template_path.name)
        copied += 1

    print(f"\n✅ Generated {copied} agent command files")
    print(f"  - Agent: {agent}")
    print(f"  - Destination: {dest_dir}")


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
        choices=["claude", "cursor", "windsurf"],
        help="target AI agent for workflow generation"
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
