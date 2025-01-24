#!/usr/bin/env bash
exec tmux new-session 'fish --init-command="function fish_prompt; echo '"'"'\$'" '"'; end"'