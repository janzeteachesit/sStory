sections = {}

makeTimeline = (d,i) ->
	timelineoptions = {
		type:       'timeline'
		width:      '100%'
		height:     '620'
		source:     d.url
		embed_id:   'timeline'+i
	}
	$(document).ready(->
	    createStoryJS(timelineoptions)
	)
		
makeBuilder = (sections) ->
    builder = d3.select("#section-summary ol")
    
    sectionli = builder.selectAll('.section-summary-item')
    .data(sections)
    .enter().append("li")
        .attr("class", "section-summary-item")
#        .text((d,i) -> i)
            
    summaryheader = sectionli.append("div").attr("class", "summary-header")        
    summaryheader.append("h4").text((d,i) -> 
        if d.title isnt undefined
            d.title
        else
            "> No title given."
    )    
    summaryheader.append("div").attr("class", "sectiontype").text((d,i) -> d.type)
       
    summarycontent = sectionli.append("div").attr("class", "summary-content")
    summarycontent.append("div").attr("class", "image-url").text((d,i) -> d.url)        
#    summarycontent.append("div").attr("class", "sectiontext").text((d,i) -> d.caption)

correctInputs = ->
    switch $('#type').val() 
        when "image"
            $('#embed-wrapper').hide()        
            $('#caption').hide()
            $('#url-wrapper').show();
        when "image2"
            $('#embed-wrapper').hide()        
            $('#caption').show()
            $('#url-wrapper').show()
            $('#caption').attr("rows", 2)
        when "image3"
            $('#embed-wrapper').hide()        
            $('#caption').show()
            $('#url-wrapper').show();
            $('#caption').attr("rows", 5)
        when "vimeo"
            $('#embed-wrapper').hide()
            $('#caption').show()
            $('#url-wrapper').show();            
        when "soundcloud"
            $('#embed-wrapper').show()        
            $('#caption').hide()
            $('#url-wrapper').hide();
        when "timeline"
            $('#embed-wrapper').hide()        
            $('#caption').hide()
            $('#url-wrapper').show();       
        when "text"
            $('#embed-wrapper').hide()        
            $('#caption').show()
            $('#url-wrapper').hide();                         
            
getJsonCode = ->
    $('#json-code').val(JSON.stringify(sections)).show()
    
submitNewSection = ->
    section = {}
    
    $("#error-bar").html("").css("opacity", 0);
    
    section.title = $("#add-section #title").val();
    section.url = $("#add-section #url").val();
    section.caption = $("#add-section #caption textarea").val();    
    section.type = $("#add-section #type").val();
    section.embed = $("#add-section #embed").val();
    
    console.log "New #{section.type} section", section
    
    
    
    if section.title is ""
        $("#error-bar").html("Every section needs a title, could you add one?").css("opacity", 1)
        return false
    else if section.url is "" and section.type isnt "text"
        $("#error-bar").html("Looks like you forgot to add the URL.").css("opacity", 1)
        return false
    else if section.type is "image2" and section.caption is ""
        $("#error-bar").html("This section type needs a caption.").css("opacity", 1)
        return false
    else if section.type is "image3" and section.caption is ""
        $("#error-bar").html("This section type needs a caption.").css("opacity", 1)
        return false
    else if section.type is "text" and section.caption is ""
        $("#error-bar").html("I think you may have forgotten your text!").css("opacity", 1)
        return false
    
    if section.type is "image" or section.type is "image2" or section.type is "image3"
        sections.push({
            title: section.title
            type: section.type
            url: section.url
            caption: section.caption
            })
    else if section.type is "vimeo"
        sections.push({
            title: section.title
            type: section.type
            url: section.url
            caption: section.caption
        })
    else if section.type is "soundcloud"
        sections.push({
            title: section.title
            type: section.type
            embed: section.embed
        })
    else if section.type is "text"
        sections.push({
            title: section.title
            type: section.type
            text: section.caption
        })    

    $("#container").html("");
    $("#section-summary ol").html("");
    sStory(sections)
    makeBuilder(sections)

            
sStory = (sections) ->    

    makeBuilder(sections)
    container = d3.select("#container")
    container.selectAll('.section')
    .data(sections)
    .enter().append("div")
        .attr("class", (d,i) ->
	 			return "section "+d.type+" "+d.type+i
				)
        .html((d,i) ->
            switch d.type
                when "text"
                    html = ich.text(d, true)
                when "image"
                    html = ich.image(d, true)
                when "image2"
                    html = ich.image2(d, true)
                when "image3"
                    html = ich.image3(d, true)
                when "vimeo"
                    html = ich.vimeo(d, true)										
                when "soundcloud"
                    html = ich.soundcloud(d, true)                    
                when "map"
                    console.log "map"
                when "timeline"
                    html = "<h2>"+d.title+"</h2> "
                    html += "<div id='timeline"+i+"'></div>"
                    makeTimeline(d,i)
#                    console.log "timeline"
              
            return html
        )
				.style("background-image", (d,i) ->
				    if d.type is "image" or d.type is "image2" or d.type is "image3"
					    return "url('"+d.url+"')"
				)