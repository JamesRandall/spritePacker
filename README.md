# Sprite Packer

![Alt text](/screenshots/2.png?raw=true "Screenshot")

A simple sprite packer that is packed as both desktop and CLI apps. The desktop version is available on the App Store and both versions can be found in the Releases section.

The desktop app is hopefully fairly self-explanatory. The CLI is self describing. Run:

    sprite-packer --help

Unique-ish features are:

* You can select SVG images as well as bitmap formats.
* With SVGs you can optionally provide a "scale to fit" size and also optionally set a root fill colour. This is useful when working with Fontawesome (for example).
* The CLI tool will allow you to drop a JSON file in a source image folder that controls the import. Just makes it easy to set up pipelines / reusable tasks. The JSON format can be found in the CLI help. If you provide switches they will take precedence over the JSON.

You're welcome to contribute. Code is a little rough - was thrown together spur of the moment to help me with MetalUI.
