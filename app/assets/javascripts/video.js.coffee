$ ->
  window.MultimediaFile ||= {}
  MultimediaFile.get_provider = (url)->
    for k,v of MultimediaFile.regexp
      for pattern in v
        regex = new RegExp(pattern)
        if matches = regex.exec(url)
          return [k, matches[1]]
    return false
  MultimediaFile.get_thumbnail = (obj)->
    provider = $(obj).data('provider')
    id = $(obj).data('id')
    switch provider
      when 'youtube' then $(obj).trigger('mf:thumb_ready', "//i.ytimg.com/vi/#{id}/hqdefault.jpg")
      when 'dailymotion'
        $.ajax
          type: "GET"
          url: "https://api.dailymotion.com/video/#{encodeURIComponent(id)}?fields=thumbnail_large_url"
          dataType: "jsonp"
          success: (data) ->
            $(obj).trigger('mf:thumb_ready', data.thumbnail_large_url.replace("http:",""))
      when 'vimeo'
        $.ajax
          type: 'GET'
          url: "http://vimeo.com/api/v2/video/#{id}.json"
          jsonp: 'callback'
          dataType: 'jsonp'
          success: (data) ->
            $(obj).trigger('mf:thumb_ready', data[0].thumbnail_large.replace("http:",""))
      else $(obj).trigger('mf:thumb_ready', "https://placeholdit.imgix.net/~text?txtsize=33&txt=350%C3%97150&w=130&h=100")

  MultimediaFile.get_player = (provider, id)->
    switch provider
      when 'youtube' then iframe_url = "//www.youtube.com/embed/#{id}?wmode=transparent"
      when 'dailymotion' then iframe_url = "//www.dailymotion.com/embed/video/#{id}?wmode=transparent"
      when 'vimeo' then iframe_url = "//player.vimeo.com/video/#{id}?badge=0&wmode=transparent"
    "<iframe width='550' height='300' src='#{iframe_url}' frameborder='0' allowfullscreen='true' webkitallowfullscreen='true' mozallowfullscreen='true'></iframe>"

  if $('body').data('controller') == 'multimedia_files_controller' and $('body').data('action') == 'index'
    $('.video-thumb').on 'mf:thumb_ready', (event, thumbnail)->
      $(this).css backgroundImage: "url(#{thumbnail})"
    $('.video-thumb').each ->
      MultimediaFile.get_thumbnail this
    $('.multimedia-file-overlay').on 'click', ->
      video = $(@).prev('.video-thumb')
      if video.length > 0
        $("#show-multimedia-file-dialog-label").text video.data('title')
        $("#show-multimedia-file-dialog .modal-body").html ->
          MultimediaFile.get_player video.data('provider'), video.data('id')
        $('a[data-target="#show-multimedia-file-dialog"]').trigger 'click'
        $('#show-multimedia-file-dialog button.close').click ->
          $("#show-multimedia-file-dialog .modal-body").html ""
          $("#show-multimedia-file-dialog-label").text ""

  if $('body').data('controller') == 'multimedia_files_controller'
    if $('#multimedia_file_video_url').length > 0
      $('.video-thumb').on 'mf:thumb_ready', (event, thumbnail)->
        $(this).css backgroundImage: "url(#{thumbnail})"
      if $('.video-thumb').data('id')
        MultimediaFile.get_thumbnail $('.video-thumb')
      $('#multimedia_file_video_url').on 'change', ->
        $('.video-thumb').css backgroundImage: "url(https://placeholdit.imgix.net/~text?txtsize=33&txt=350%C3%97150&w=130&h=100)"
        if res = MultimediaFile.get_provider $(@).val()
          $('#multimedia_file_video_provider').val(res[0])
          $('#provider_placeholder').val(res[0])
          $('.multimedia-file').show()
          $('.video-thumb').data('provider', res[0])
          $('.video-thumb').data('id', res[1])
          MultimediaFile.get_thumbnail $('.video-thumb')
        else
          $('#multimedia_file_video_provider').val("")
          $('#provider_placeholder').val("")
