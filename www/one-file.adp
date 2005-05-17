<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="displayed_object_id">@file_id@</property>
<p>
<a class="button" href="@edit_url@">Edit Content</a>
</p>
<h3>#lors-central.this_file_has#:</h3>
<listtemplate name="file_list"></listtemplate>
<br>

<h3>#lors-central.and_is_in#:</h3>
<listtemplate name="course_list"></listtemplate>
</div>
<hr><h1>#lors-central.preview#</h1>
<if @prev_type@ eq "image"> 
    <img src="download?version_id=@file_id@">
</if>
<else>
    <include src="download/preview" version_id=@file_id@>
</else>
