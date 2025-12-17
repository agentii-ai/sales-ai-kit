"""Sales-AI-Kit: Spec-driven development for AI/LLM SaaS sales and marketing.

This package provides collision-free multi-kit coexistence via namespace isolation
while preserving the Spec-Kit workflow shape (constitution → specify → plan → tasks → implement).

Namespace Strategy:
- CLI executable: `sales`
- Distribution name: `sales-cli`
- Module namespace: `saleskit`
- Kit folder: `.saleskit/`
- Slash commands: `saleskit.*` (/saleskit.specify, /saleskit.plan, etc.)
"""

__version__ = "0.1.0"
__all__ = ["cli"]
