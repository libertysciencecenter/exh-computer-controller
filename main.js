$(function(){

	var checkboxsChecked = 0;


	$.get('http://api.lsc.local/v1/cache/getgroupkeys/?group=EXHCOMPUTERCOMMAND', function(data) {
	  
		$('#loading').slideUp();

		var n = data.split(",")

		console.log(n)
		
		for (var i = 0; i < n.length; i++) {
			if (n[i].length > 2)
				$('tbody').append(createItem(n[i]));
		}
		
		//Set all table stuff
		$("table button:contains('Shutdown')").click(function(){
			$.get('http://api.lsc.local/v1/cache/set/?group=EXHCOMPUTERCOMMAND&value=CMD:SHUTDOWN&key='+$(this).parents('tr').data('id'))
		})

		$("table button:contains('Restart')").click(function(){
			$.get('http://api.lsc.local/v1/cache/set/?group=EXHCOMPUTERCOMMAND&value=CMD:RESTART&key='+$(this).parents('tr').data('id'))
		})

		$("table button:contains('Command')").click(function(){
			var cmd = prompt("Enter your commands(no spaces,|newline| for newline:", "")
			if (cmd != null)
				$.get('http://api.lsc.local/v1/cache/set/?group=EXHCOMPUTERCOMMAND&value=EVAL:'+cmd+'&key='+$(this).parents('tr').data('id'))
		})

		$("table input").click(function(){
			checkboxsChecked++;
			if (checkboxsChecked > 1)
				$('.btn-group').slideDown();
		})

		//Set all forms stuff
		$(".form-actions button:contains('Shutdown')").click(function(){
			$('input:checkbox').each(function () {
			       var isChecked = (this.checked ? $(this).val() : "");
			       if (isChecked)
			       		$.get('http://api.lsc.local/v1/cache/set/?group=EXHCOMPUTERCOMMAND&value=CMD:SHUTDOWN&key='+$(this).parents('tr').data('id'))
			 });

			$('input').prop('checked', false);
		})

		$(".form-actions button:contains('Restart')").click(function(){
			$('input:checkbox').each(function () {
			       var isChecked = (this.checked ? $(this).val() : "");
			       if (isChecked)
			       		$.get('http://api.lsc.local/v1/cache/set/?group=EXHCOMPUTERCOMMAND&value=CMD:RESTART&key='+$(this).parents('tr').data('id'))
			 });

			$('input').prop('checked', false);
		})

		$(".form-actions button:contains('Command')").click(function(){

			var cmd = prompt("Enter your commands(no spaces,|newline| for newline:", "")
			
			if (cmd != null)
				$('input:checkbox').each(function () {
				       var isChecked = (this.checked ? $(this).val() : "");
				       if (isChecked)
				       		$.get('http://api.lsc.local/v1/cache/set/?group=EXHCOMPUTERCOMMAND&value=EVAL:'+cmd+'&key='+$(this).parents('tr').data('id'))
				 });

			$('input').prop('checked', false);
		})

		$(".form-actions button:contains('Select All')").click(function(){
			$('.btn-group').slideDown();
			$('input').prop('checked', true);
		})

	});

	function createItem(name){
		var tmpl;

		tmpl = '<tr>'
		tmpl += '<td> <input type="checkbox"></td>'
		tmpl += '<td>'+name+'</td>'
		tmpl += 	'<td class="td-actions"><div class ="btn-group">'
		tmpl += 		'<button type="button" class="btn btn-danger">Shutdown</button>'
		tmpl += 		'<button type="button" class="btn btn-warning">Restart</button>'
		tmpl += 		'<button type="button" class="btn btn-info">Command</button>'
		tmpl += 	'</div></td>'
		tmpl += '</tr>'

		return $(tmpl).data('id', name);
	}

})

