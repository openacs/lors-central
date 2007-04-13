<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="displayed_object_id">@displayed_object_id@</property>

<h1>@name@<a href="@edit_name_url@"><img border=0 src="/resources/acs-subsite/Edit16.gif"></a></h1>
<a class=button href="tracking/?man_id=@man_id@&item_id=@ims_item_id@" title="#lors-central.All_views_of#">#lors-central.All_views#</a>
<a class="button" href="md/pbs-md/?ims_md_id=@displayed_object_id@">Edit Metadata</a>
<a class="button" href="one-resource?res_id=@res_id@">All Resources</a>
<h3>Versions of this learning object:</h3>
<listtemplate name="item_versions"></listtemplate>

<h3>#lors-central.This_learning_obj#</h3>

<listtemplate name="courses"></listtemplate>

<include src="/packages/lors-central/lib/item-files/" ims_item_id="@displayed_object_id@">

<!-- h3>Clipboard</h3 -->
<!-- include src="/packages/lors-central/lib/clipboard" -->
</div>

<hr><h1>Preview of "Live Version"</h1>

<if @prev_type@ eq "image"> 
    <img src="download?version_id=@file_revision@">
</if>
<else>
    <include src="download/preview" file_id=@file_revision@>
</else>

