{% assign doclist = site.pages | sort: 'url' %}

<ul>
  {% for doc in doclist %} 
  {{doc.url}}
  {{doc.name}}
  {% if doc.name contains '.md' or doc.name contains
  '.html' %}
  <li><a href="{{ site.baseurl }}{{ doc.url }}">{{ doc.name }}</a></li>
  {% endif %} {% endfor %}
</ul>
