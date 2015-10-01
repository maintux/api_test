$ ->
  window.MultimediaFile ||= {}

  window.MultimediaFile.template_options = {
    evaluate: /<#([\s\S]+?)#>/g
    interpolate: /\{\{\{([\s\S]+?)\}\}\}/g
    escape: /\{\{([^\}]+?)\}\}(?!\})/g
    variable: 'data'
  }

  window.MultimediaFile.image_template = $('#tmpl-uploader-multimedia-file')

  window.MultimediaFile.emptyQueueHandler= (event)->
    event.preventDefault()
    $el = $('#media-upload-photo')
    $el.find('.upload_queue_container li .media-queue-remove-icon').trigger 'click'

  window.MultimediaFile.uploadQueueHandler= (event)->
    event.preventDefault()
    $el = $('#media-upload-photo')
    console.log @uploader
    if window.MultimediaFile.uploader and !$('#upload-image-button').hasClass('disabled')
      $('#upload-image-button').addClass('disabled')
      extra_params = {}
      form = $el.find('.media-select-uploader-form')
      form.find('input, select, textarea').each ->
        extra_params[$(@).attr('name')] = $(@).val()
        $(@).prop 'disabled', true
      window.MultimediaFile.uploader.settings.multipart_params = _.extend window.MultimediaFile.uploader.settings.multipart_params, extra_params
      $el.find('.progress').css({display: 'inline-block'})
      window.MultimediaFile.uploader.start()
      $el.find('.upload_queue_container li .media-queue-remove-icon').hide()
      $el.find('.upload_queue_container #uploader-add-more').hide()
      $el.find('#empty-queue-link').hide()
      $(@).blur()


  window.MultimediaFile.dragAndDropHandler = ->
    $el = $('#media-upload-photo')
    if @uploader and @uploader.runtime == 'html5'
      drag_notify = $el.find('#drag-notify')
      $el.on 'dragenter', (e)->
        e.stopPropagation()
        e.preventDefault()
        drag_notify.show()
      drag_notify.on 'dragleave', (e)->
        e.stopPropagation()
        e.preventDefault()
        if e.target.tagName.toLowerCase() != 'h2'
          drag_notify.hide()
      drag_notify.on 'drop', (e)->
        drag_notify.hide()

  window.MultimediaFile.uploader = new plupload.Uploader
    url: $('#media-upload-photo').find('.media-select-uploader-form').attr('action')
    runtimes: 'html5,flash,silverlight,html4'
    browse_button: ['media-select-uploader-link', 'uploader-add-more-link']
    multi_selection: true
    multipart_params:
      format: 'json'
    file_data_name: "multimedia_file_image[attachment]"
    drop_element: 'media-upload-photo'
    filters:
      max_file_size : '8mb'
      prevent_duplicates: true
      mime_types: [
        title: "Image files"
        extensions: "jpg,gif,png,jpeg"
      ]
    init:
      PostInit: ->
        MultimediaFile.dragAndDropHandler()
        $('#upload-image-button').on 'click', MultimediaFile.uploadQueueHandler
        $('#empty-queue-link').on 'click', MultimediaFile.emptyQueueHandler
        $el = $('#media-upload-photo')
        $el.find('#selected_count').html "<strong>0 / 0</strong> files uploaded"

      FilesAdded: (up, files)->
        $el = $('#media-upload-photo')
        if $el.find('.media-upload-first-step').is(':visible')
          $el.find('.media-upload-first-step').hide()
          $el.find('.media-upload-second-step').show()
          $el.find('.media-select-tab-footer').show()
        queue_container = $el.find('.upload_queue_container')
        _.each files, (file)->
          preloader = new mOxie.Image()

          preloader.onload = ->
            preloader.downsize 138, 138, true
            $("li[data-item=#{file.id}] img").prop "src", preloader.getAsDataURL()

          t = _.template(MultimediaFile.image_template.html(), MultimediaFile.template_options)
          queue_container.find('.media-upload-collection #uploader-add-more').before t(file)

          queue_container.find("li[data-item=#{file.id}] .media-queue-remove-icon").on 'click', (event)->
            event.preventDefault()
            up.removeFile file
            $(@).parents('li').remove()
            $el.find('#selected_count').html "<strong>0 / #{up.total.queued}</strong> files uploaded"
            if up.total.queued == 0
              $el.find('.media-upload-first-step').show()
              $el.find('.media-upload-second-step').hide()
              $el.find('.media-select-tab-footer').hide()
              $el.find('#selected_count').hide()
              $el.find('.progress').hide()
              $el.find('.progress .bar').css({width: 0})

          preloader.load file.getSource()

        $el.find('#selected_count').html "<strong>0 / #{up.total.queued}</strong> files uploaded"
        $el.find('#selected_count').show()

      BeforeUpload: (up, file)->
        $el = $('#media-upload-photo')
        $el.find('.upload_queue_container').find("li[data-item=#{file.id}] .media-queue-overlay").show()

      UploadProgress: (up, file)->
        $el = $('#media-upload-photo')
        total = up.total.queued + up.total.uploaded
        single_total = 100 / total
        single_unit = 1 / total
        percentual = single_unit*file.percent
        final = percentual + (single_total * up.total.uploaded)
        $el.find('.progress .bar').css({width: "#{final}%"})

      FileUploaded: (up, file, xhr) ->
        $el = $('#media-upload-photo')
        $el.find('#selected_count').html "<strong>#{up.total.uploaded} / #{up.total.queued+up.total.uploaded}</strong> files uploaded"
        $el.find('.upload_queue_container').find("li[data-item=#{file.id}]").fadeOut ->
          $(@).remove()

      UploadComplete: (up, files) ->
        $el = $('#media-upload-photo')
        up.total.reset()
        up.splice()
        $('#upload-image-button').removeClass('disabled')
        $el.find('.upload_queue_container #uploader-add-more').show()
        $el.find('.media-upload-first-step').show()
        $el.find('.media-upload-second-step').hide()
        $el.find('.media-select-tab-footer').hide()
        $el.find('#selected_count').html "<strong>0 / 0</strong> files uploaded"
        $el.find('#selected_count').hide()
        $el.find('.progress').hide()
        $el.find('.progress .bar').css({width: 0})
        $el.find('#empty-queue-link').show()
        form = $el.find('.media-select-uploader-form')
        form.find('input, select, textarea').each ->
          $(@).prop 'disabled', false
        document.location.href = "/multimedia_files"

  if $('#media-upload-photo').length > 0
    MultimediaFile.uploader.init()

  if $('body').data('controller') == 'multimedia_files_controller' and $('body').data('action') == 'index'
    $('.multimedia-file-overlay').on 'click', ->
      image = $(@).prev('.image-thumb')
      if image.length > 0
        $("#show-multimedia-file-dialog-label").text image.data('title')
        $("#show-multimedia-file-dialog .modal-body").html "<img src='#{image.data('url')}' style='max-width: 550px; margin: 0 auto;' />"
        $('a[data-target="#show-multimedia-file-dialog"]').trigger 'click'
        $('#show-multimedia-file-dialog button.close').click ->
          $("#show-multimedia-file-dialog .modal-body").html ""
          $("#show-multimedia-file-dialog-label").text ""