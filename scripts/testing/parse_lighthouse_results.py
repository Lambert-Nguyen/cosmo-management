#!/usr/bin/env python3
"""
Parse Lighthouse JSON reports and display formatted results
"""

import json
import glob
import os
from pathlib import Path

def parse_lighthouse_report(json_path):
    """Parse a Lighthouse JSON report and extract key metrics"""
    try:
        with open(json_path, 'r') as f:
            data = json.load(f)
        
        categories = data.get('categories', {})
        
        def get_score(category_name):
            score = categories.get(category_name, {}).get('score')
            return int(score * 100) if score is not None else None
        
        return {
            'performance': get_score('performance'),
            'accessibility': get_score('accessibility'),
            'best_practices': get_score('best-practices'),
            'seo': get_score('seo'),
            'url': data.get('finalDisplayedUrl', 'Unknown'),
            'fetch_time': data.get('fetchTime', 'Unknown')
        }
    except Exception as e:
        print(f"Error parsing {json_path}: {e}")
        return None

def format_score(score, threshold_good, threshold_ok=None):
    """Format score with color coding"""
    if score is None:
        return "❓ N/A"
    
    if threshold_ok is None:
        threshold_ok = threshold_good - 10
    
    if score >= threshold_good:
        return f"✅ {score}"
    elif score >= threshold_ok:
        return f"⚠️  {score}"
    else:
        return f"❌ {score}"

def main():
    # Find all Lighthouse JSON reports
    report_dir = Path(__file__).parent.parent.parent / 'docs' / 'reports' / 'lighthouse'
    json_files = sorted(glob.glob(str(report_dir / '*.report.json')))
    
    if not json_files:
        print("❌ No Lighthouse reports found in", report_dir)
        return 1
    
    print("=" * 60)
    print("LIGHTHOUSE AUDIT RESULTS")
    print("=" * 60)
    print()
    
    reports = []
    for json_file in json_files:
        result = parse_lighthouse_report(json_file)
        if result:
            page_name = Path(json_file).stem.replace('_20251208', '').replace('_', ' ').title()
            page_name = page_name.replace('.Report', '')
            result['name'] = page_name
            reports.append(result)
    
    if not reports:
        print("❌ Failed to parse any reports")
        return 1
    
    # Display individual results
    for report in reports:
        print(f"📄 {report['name']}")
        print(f"   URL: {report['url']}")
        print()
        print(f"   Performance:    {format_score(report['performance'], 90, 50)}")
        print(f"   Accessibility:  {format_score(report['accessibility'], 95, 80)}")
        print(f"   Best Practices: {format_score(report['best_practices'], 90, 80)}")
        print(f"   SEO:            {format_score(report['seo'], 90, 80)}")
        print()
    
    # Calculate averages
    print("=" * 60)
    print("AVERAGE SCORES")
    print("=" * 60)
    print()
    
    valid_reports = [r for r in reports if all([
        r['performance'] is not None,
        r['accessibility'] is not None,
        r['best_practices'] is not None,
        r['seo'] is not None
    ])]
    
    if valid_reports:
        avg_perf = sum(r['performance'] for r in valid_reports) // len(valid_reports)
        avg_access = sum(r['accessibility'] for r in valid_reports) // len(valid_reports)
        avg_bp = sum(r['best_practices'] for r in valid_reports) // len(valid_reports)
        avg_seo = sum(r['seo'] for r in valid_reports) // len(valid_reports)
        
        print(f"📊 Pages Audited: {len(valid_reports)}")
        print()
        print(f"Performance:    {format_score(avg_perf, 90)} (Target: ≥90)")
        print(f"Accessibility:  {format_score(avg_access, 95)} (Target: ≥95)")
        print(f"Best Practices: {format_score(avg_bp, 90)}")
        print(f"SEO:            {format_score(avg_seo, 90)}")
        print()
        
        # Phase 4 criteria check
        print("=" * 60)
        print("PHASE 4 SUCCESS CRITERIA")
        print("=" * 60)
        print()
        
        perf_pass = avg_perf >= 90
        access_pass = avg_access >= 95
        
        print(f"✅ Performance ≥90:    {'PASS' if perf_pass else 'FAIL'}")
        print(f"✅ Accessibility ≥95:  {'PASS' if access_pass else 'FAIL'}")
        print()
        
        if perf_pass and access_pass:
            print("🎉 ALL PERFORMANCE & ACCESSIBILITY TARGETS MET!")
            return 0
        else:
            print("⚠️  Some targets not met. Recommendations:")
            if not perf_pass:
                print("   - Optimize images and assets")
                print("   - Minimize JavaScript execution")
                print("   - Enable browser caching")
            if not access_pass:
                print("   - Add missing alt text to images")
                print("   - Improve color contrast")
                print("   - Add ARIA labels to interactive elements")
            return 1
    else:
        print("❌ No valid reports to calculate averages")
        return 1

if __name__ == '__main__':
    exit(main())
