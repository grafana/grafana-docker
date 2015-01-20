// see config.js.example for grafana

define(['settings'], function(Settings) {
    "use strict";

    return new Settings({
        datasources: {
            {% if GRAFANA_GRAPHITE_SERVERS is defined %}
            graphite: {
                type: 'graphite',
                url: '/graphite',
            },
            {% endif %}

            {% if GRAFANA_ES_SERVERS is defined %}
            elasticsearch: {
                type: 'elasticsearch',
                url: '/es',
                index: '{{ GRAFANA_ES_INDEX | default("grafana-dash") }}',
                grafanaDB: true,
            },
            {% endif %}
        },

        search: {
          max_results: {{ GRAFANA_SEARCH_MAX_RESULTS | default(100) }}
        },

        default_route: '{{ GRAFANA_DEFAULT_ROUTE | default("/dashboard/file/default.json") }}',

        unsaved_changes_warning: {{ GRAFANA_UNSAVED_CHANGES_WARNING | default('true') }},

        playlist_timespan: '{{ GRAFANA_PLAYLIST_TIMESPAN | default("1m") }}',

        admin: {
          password: '{{ GRAFANA_SAVING_ADMIN_PASSWORD | default("") }}'
        },

        window_title_prefix: '{{ GRAFANA_WINDOW_TITLE_PREFIX | default("Grafana - ") }}',

        plugins: {
          panels: [],
          dependencies: [],
        }

    });
});
