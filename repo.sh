#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.bz2 Packages.xz Packages.zst Release Release.gpg

echo "[Repository] Generating Packages..."
apt-ftparchive packages ./pool > Packages
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2

echo "[Repository] Generating Release..."
apt-ftparchive \
		-o APT::FTPArchive::Release::Origin="ballpa1n repository" \
		-o APT::FTPArchive::Release::Label="ballpa1n repository" \
		-o APT::FTPArchive::Release::Suite="stable" \
		-o APT::FTPArchive::Release::Version="420.69" \
		-o APT::FTPArchive::Release::Codename="ios" \
		-o APT::FTPArchive::Release::Architectures="iphoneos-arm" \
		-o APT::FTPArchive::Release::Components="main" \
		-o APT::FTPArchive::Release::Description="A repository for necessary packages for the ballpa1n untether." \
		release . > Release

echo "[Repository] Signing Release using Azreal's GPG Key..."
gpg -abs -u 3CE1F7C9015A9450D6D6906004AFD16F1DE3C455 -o Release.gpg Release

echo "[Repository] Finished"
