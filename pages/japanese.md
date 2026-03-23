---
layout: default
title: Japanisch
permalink: /art/japanese
---

<div class="container mt-6">
    <div class="fixed-grid has-3-cols">
  <div class="grid">          
     {% for art in site.data.japanese %}
    <div class="cell"> {% include art-card.html art=art type="japanese" %}</div>
    {% endfor %}
  </div>
    </div>
</div>
