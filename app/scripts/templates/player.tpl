<img class="img-polaroid <%= position === 'left' ? 'pull-left' : 'pull-right' %>" src="<%= photo_small %>">
<div class="media-body">
  <h4 class="media-heading"><%= username %>
  </h4>
  <% for (var i = 0; i < lives; i++) { %>
    <img class="media-object <%= position === 'left' ? 'pull-left' : 'pull-right' %>" src="/images/small_plant.png">
  <% } %>
</div>
<div id="courses"></div>
<button class="btn btn-block" data-toggle="button" type="button">Ready!</button>