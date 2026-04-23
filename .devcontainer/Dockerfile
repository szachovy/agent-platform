FROM node:20

ARG TARGETARCH
ARG AGENT_PLATFORM_CLAUDE_CODE_VERSION
ARG AGENT_PLATFORM_CODEX_VERSION
ARG AGENT_PLATFORM_OPENCODE_VERSION
ARG AGENT_PLATFORM_BACKLOG_MD_VERSION
ARG AGENT_PLATFORM_CONTEXT7_VERSION
ARG AGENT_PLATFORM_ZSH_IN_DOCKER_VERSION
ARG AGENT_PLATFORM_TZ

ENV \
  NPM_CONFIG_PREFIX="/usr/local/share/npm-global" \
  PATH="/usr/local/share/npm-global/bin:/home/node/.local/bin:${PATH}" \
  SHELL="/bin/zsh" \
  EDITOR="nano" \
  VISUAL="nano" \
  POWERLEVEL9K_DISABLE_GITSTATUS="true" \
  TZ="${AGENT_PLATFORM_TZ}" \
  LANG='en_US.UTF-8' \
  LANGUAGE='en_US:en' \
  LC_ALL='en_US.UTF-8'

COPY --chmod=0555 "init-firewall.sh" "/usr/local/bin/init-firewall.sh"
COPY --chmod=0555 "access.sh" "/usr/local/bin/access.sh"
COPY --chmod=0444 "sudoers" "/etc/sudoers.d/sudoers"
COPY --chmod=0664 ".trufflehog-exclude" "/home/node/.trufflehog-exclude"
COPY --chown=node:node --chmod=0774 "config/claude" "/home/node/.claude"
COPY --chown=node:node --chmod=0774 "config/codex" "/home/node/.codex"
COPY --chown=node:node --chmod=0774 "config/opencode" "/home/node/.opencode"
COPY --chown=node:node --chmod=0774 "skills" "/usr/local/share/agent-platform/skills"

RUN \
  apt-get update && \
  apt-get install --yes --no-install-recommends \
    python3-pip \
    less \
    git \
    gh \
    procps \
    sudo \
    fzf \
    zsh \
    man-db \
    unzip \
    gnupg2 \
    iptables \
    ipset \
    iproute2 \
    dnsutils \
    aggregate \
    jq \
    nano \
    vim \
    moreutils && \
  apt-get clean && \
  rm --recursive --force "/var/lib/apt/lists/*" && \
  mkdir --parents "/usr/local/share/npm-global" "/workspace" "/commandhistory" "/etc/claude-code/" "/etc/codex" "/etc/opencode" "/home/node/.claude" "/home/node/.codex" "/home/node/.opencode" && \
  touch "/commandhistory/.bash_history" && \
  chown --recursive node:node "/usr/local/share" "/workspace" "/commandhistory" "/home/node/.claude" "/home/node/.codex" "/home/node/.opencode" && \
  chown --recursive root:root "/etc/claude-code/" "/etc/codex" "/etc/opencode" && \
  mv "/home/node/.claude/managed-settings.json" "/etc/claude-code/" && \
  mv "/home/node/.codex/managed_config.toml" "/etc/codex/" && \
  mv "/home/node/.opencode/managed_config.json" "/etc/opencode/" && \
  chmod 0664 "/etc/claude-code/managed-settings.json" "/etc/codex/managed_config.toml" "/etc/opencode/managed_config.json" && \
  chown root:root "/etc/claude-code/managed-settings.json" "/etc/codex/managed_config.toml" "/etc/opencode/managed_config.json" && \
  ln --symbolic "/etc/opencode/managed_config.json" "/home/node/.opencode/managed_config.json"

USER node

RUN \
  sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${AGENT_PLATFORM_ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
    -p git \
    -p fzf \
    -a 'export OPENCODE_CONFIG_CONTENT="$(jq -c . /etc/opencode/managed_config.json 2>/dev/null || printf "{}")"' \
    -a 'source /usr/share/doc/fzf/examples/key-bindings.zsh' \
    -a 'source /usr/share/doc/fzf/examples/completion.zsh' \
    -a 'export HISTFILE=/commandhistory/.bash_history' \
    -a 'export HISTSIZE=-1' \
    -a 'export SAVEHIST=-1' \
    -a 'setopt APPEND_HISTORY' \
    -a 'setopt INC_APPEND_HISTORY' \
    -a 'setopt SHARE_HISTORY' \
    -a 'setopt HIST_IGNORE_ALL_DUPS' \
    -a 'setopt HIST_IGNORE_SPACE' \
    -x && \
  npm install --global "@anthropic-ai/claude-code@${AGENT_PLATFORM_CLAUDE_CODE_VERSION}" && \
  npm install --global "@openai/codex@${AGENT_PLATFORM_CODEX_VERSION}" && \
  npm install --global "opencode-ai@${AGENT_PLATFORM_OPENCODE_VERSION}" && \
  npm install --global "backlog.md@${AGENT_PLATFORM_BACKLOG_MD_VERSION}" && \
  npm install --global "@upstash/context7-mcp@${AGENT_PLATFORM_CONTEXT7_VERSION}" && \
  for agent_skills in /home/node/.claude/skills /home/node/.codex/skills /home/node/.opencode/skills; do \
    mkdir --parents "$agent_skills" && \
    ln --symbolic --force /usr/local/share/agent-platform/skills/SKILL.md "$agent_skills/SKILL.md" && \
    find /usr/local/share/agent-platform/skills/public /usr/local/share/agent-platform/skills/private -mindepth 1 -maxdepth 1 -type d -exec ln --symbolic --force --target-directory="$agent_skills" {} +; \
  done && \
  mkdir --parents "/home/node/.local/bin" && \
  TRUFFLEHOG_VERSION=$(curl -fsSL https://api.github.com/repos/trufflesecurity/trufflehog/releases/latest | jq -r '.tag_name' | sed 's/^v//') && \
  curl -fsSL "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_linux_${TARGETARCH}.tar.gz" | tar xz -C /tmp && \
  mv /tmp/trufflehog /home/node/.local/bin/trufflehog

USER root
RUN chown --recursive root:root "/usr/local/share/npm-global"

USER node
WORKDIR /workspace
