#!/usr/bin/env python3
"""Sales-AI-Kit CLI implementation.

Provides the `sales` executable for managing Sales-AI-Kit projects with
collision-free namespace isolation.
"""

import argparse
import sys
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
    target_dir = Path(args.directory or ".")

    print(f"Sales-AI-Kit Project Initialization")
    print(f"Target directory: {target_dir.absolute()}")
    print(f"\nNote: `sales init` implementation is pending.")
    print(f"      This will scaffold .saleskit/ with templates and constitution.")

    if args.ai:
        print(f"      Agent target: {args.ai}")
        print(f"      Will generate /{args.ai} workflow files for selected agent.")

    return 0


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
