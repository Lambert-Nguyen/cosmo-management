#!/usr/bin/env python3
"""
Template Migration Script for Phase 3: Base Template Unification

This script automates the conversion of existing templates to use the new unified base architecture:
- Updates {% extends %} tags to use new layout templates
- Converts title blocks to page_title blocks
- Creates backups before modification
- Validates template structure
- Generates migration report

Usage:
    python api/migrate_templates.py --dry-run  # Preview changes
    python api/migrate_templates.py            # Execute migration
    python api/migrate_templates.py --template staff/my_tasks.html  # Migrate specific file
"""

import os
import re
import shutil
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Tuple

# Template directory (relative to script location)
TEMPLATE_DIR = Path(__file__).parent / "templates"
BACKUP_DIR = Path(__file__).parent / "templates_backup"

# Migration mappings: old base → new layout
LAYOUT_MAPPINGS = {
    "staff/base.html": "layouts/staff_layout.html",
    "manager_admin/base.html": "layouts/admin_layout.html",
    "guest_portal/base.html": "layouts/portal_layout.html",
    "registration/base.html": "layouts/public_layout.html",
    "base.html": "layouts/public_layout.html",  # Generic base → public
}

# Pattern matching
EXTENDS_PATTERN = re.compile(r'{%\s*extends\s+["\']([^"\']+)["\']\s*%}')
TITLE_BLOCK_PATTERN = re.compile(
    r'{%\s*block\s+title\s*%}(.*?){%\s*endblock\s*(?:title)?\s*%}',
    re.DOTALL
)


def create_backup(file_path: Path) -> Path:
    """Create timestamped backup of template file."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = BACKUP_DIR / f"{file_path.stem}_{timestamp}{file_path.suffix}"
    backup_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(file_path, backup_path)
    return backup_path


def analyze_template(content: str, file_path: Path) -> Dict:
    """Analyze template structure and determine migration strategy."""
    analysis = {
        "file": file_path.name,
        "extends": None,
        "new_extends": None,
        "has_title_block": False,
        "title_content": None,
        "needs_migration": False,
        "issues": [],
    }
    
    # Check extends tag
    extends_match = EXTENDS_PATTERN.search(content)
    if extends_match:
        old_extends = extends_match.group(1)
        analysis["extends"] = old_extends
        
        # Determine new layout
        if old_extends in LAYOUT_MAPPINGS:
            analysis["new_extends"] = LAYOUT_MAPPINGS[old_extends]
            analysis["needs_migration"] = True
        else:
            analysis["issues"].append(f"Unknown base template: {old_extends}")
    else:
        analysis["issues"].append("No extends tag found")
    
    # Check title block
    title_match = TITLE_BLOCK_PATTERN.search(content)
    if title_match:
        analysis["has_title_block"] = True
        analysis["title_content"] = title_match.group(1).strip()
    
    return analysis


def migrate_template(content: str, analysis: Dict) -> str:
    """Migrate template content to new base architecture."""
    if not analysis["needs_migration"]:
        return content
    
    # Replace extends tag
    old_extends = analysis["extends"]
    new_extends = analysis["new_extends"]
    content = EXTENDS_PATTERN.sub(
        f'{{% extends "{new_extends}" %}}',
        content,
        count=1
    )
    
    # Update title block if present
    if analysis["has_title_block"]:
        title_content = analysis["title_content"]
        
        # Extract just the page title (remove " · Cosmo" suffix if present)
        page_title = title_content
        if "·" in title_content or "|" in title_content:
            page_title = re.split(r'[·|]', title_content)[0].strip()
        
        # Replace title block with page_title block
        new_title_block = f'{{% block page_title %}}{page_title}{{% endblock %}}'
        content = TITLE_BLOCK_PATTERN.sub(new_title_block, content, count=1)
    
    return content


def find_templates(directory: Path, pattern: str = "*.html") -> List[Path]:
    """Find all template files matching pattern."""
    templates = []
    for file_path in directory.rglob(pattern):
        # Skip backup directory
        if BACKUP_DIR in file_path.parents:
            continue
        # Skip layout templates
        if "layouts/" in str(file_path):
            continue
        # Skip component templates
        if "components/" in str(file_path):
            continue
        templates.append(file_path)
    return sorted(templates)


def migrate_single_template(
    file_path: Path, 
    dry_run: bool = False
) -> Tuple[bool, Dict]:
    """Migrate a single template file."""
    try:
        # Read template
        content = file_path.read_text(encoding="utf-8")
        
        # Analyze structure
        analysis = analyze_template(content, file_path)
        
        if not analysis["needs_migration"]:
            return False, analysis
        
        # Create backup
        if not dry_run:
            backup_path = create_backup(file_path)
            analysis["backup"] = str(backup_path)
        
        # Migrate content
        new_content = migrate_template(content, analysis)
        
        # Write migrated template
        if not dry_run:
            file_path.write_text(new_content, encoding="utf-8")
            analysis["migrated"] = True
        else:
            analysis["migrated"] = False
            analysis["dry_run"] = True
        
        return True, analysis
        
    except Exception as e:
        return False, {"error": str(e), "file": file_path.name}


def generate_report(results: List[Dict], dry_run: bool = False) -> str:
    """Generate migration report."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    report = [
        "=" * 80,
        "TEMPLATE MIGRATION REPORT",
        "=" * 80,
        f"Generated: {timestamp}",
        f"Mode: {'DRY RUN (no changes made)' if dry_run else 'MIGRATION EXECUTED'}",
        "",
    ]
    
    # Statistics
    total = len(results)
    migrated = sum(1 for r in results if r.get("migrated", False))
    skipped = sum(1 for r in results if not r.get("needs_migration", False))
    errors = sum(1 for r in results if "error" in r)
    
    report.extend([
        "STATISTICS",
        "-" * 80,
        f"Total templates analyzed: {total}",
        f"Migrated successfully:    {migrated}",
        f"Skipped (no migration):   {skipped}",
        f"Errors encountered:       {errors}",
        "",
    ])
    
    # Details
    if migrated > 0:
        report.extend([
            "MIGRATED TEMPLATES",
            "-" * 80,
        ])
        for result in results:
            if result.get("migrated", False):
                report.append(f"✓ {result['file']}")
                report.append(f"  Old: {result['extends']}")
                report.append(f"  New: {result['new_extends']}")
                if "backup" in result:
                    report.append(f"  Backup: {result['backup']}")
                report.append("")
    
    # Issues
    issues = [r for r in results if r.get("issues")]
    if issues:
        report.extend([
            "ISSUES FOUND",
            "-" * 80,
        ])
        for result in issues:
            report.append(f"⚠ {result['file']}")
            for issue in result["issues"]:
                report.append(f"  - {issue}")
            report.append("")
    
    # Errors
    error_results = [r for r in results if "error" in r]
    if error_results:
        report.extend([
            "ERRORS",
            "-" * 80,
        ])
        for result in error_results:
            report.append(f"✗ {result['file']}")
            report.append(f"  Error: {result['error']}")
            report.append("")
    
    report.append("=" * 80)
    return "\n".join(report)


def main():
    """Main migration workflow."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Migrate templates to unified base architecture"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview changes without modifying files"
    )
    parser.add_argument(
        "--template",
        type=str,
        help="Migrate specific template file (relative to templates/)"
    )
    parser.add_argument(
        "--report",
        type=str,
        default="migration_report.txt",
        help="Output report file path"
    )
    
    args = parser.parse_args()
    
    # Find templates to migrate
    if args.template:
        template_path = TEMPLATE_DIR / args.template
        if not template_path.exists():
            print(f"Error: Template not found: {template_path}")
            return 1
        templates = [template_path]
    else:
        templates = find_templates(TEMPLATE_DIR)
    
    print(f"Found {len(templates)} templates to analyze")
    print(f"Mode: {'DRY RUN' if args.dry_run else 'MIGRATION'}")
    print()
    
    # Migrate templates
    results = []
    for template in templates:
        print(f"Processing: {template.relative_to(TEMPLATE_DIR)}...", end=" ")
        migrated, analysis = migrate_single_template(template, args.dry_run)
        results.append(analysis)
        
        if migrated:
            print("✓ MIGRATED")
        elif "error" in analysis:
            print("✗ ERROR")
        else:
            print("○ SKIPPED")
    
    # Generate and save report
    report = generate_report(results, args.dry_run)
    print()
    print(report)
    
    report_path = Path(args.report)
    report_path.write_text(report, encoding="utf-8")
    print(f"\nReport saved to: {report_path}")
    
    return 0


if __name__ == "__main__":
    exit(main())
