"""
Entry points for the image info executables
"""
import argparse
import os
import json
import sys

from image_info.core.target import Target


def inspect():
    """
    Inspect an image
    """
    parser = argparse.ArgumentParser(description="Inspect an image")
    parser.add_argument("target", metavar="TARGET",
                        help="The file or directory to analyse",
                        type=os.path.abspath)

    args = parser.parse_args()
    json.dump(
        Target.get(args.target).inspect(),
        sys.stdout,
        sort_keys=True,
        indent=2)
