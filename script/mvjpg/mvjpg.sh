#!/bin/sh

for f; do
  mv "$f" "${f%.JPG}.jpg"
done
