<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="displayed_object_id">@displayed_object_id@</property>

<h1>@name@</h1>
<a class=button href="tracking/?man_id=@man_id@&item_id=@ims_item_id@" title="#lors-central.All_views_of#">
#lors-central.All_views#
</a>
<a class="button" href="md/pbs-md/?ims_md_id=@displayed_object_id@">Edit Metadata</a>

<h3>Versions of this learning object:</h3>
<listtemplate name="item_versions"></listtemplate>

<h3>#lors-central.This_learning_obj#</h3>

<listtemplate name="courses"></listtemplate>

<!-- include src="/packages/lors-central/lib/item-files/" ims_item_id="@displayed_object_id@" man_id="@man_id@" org_id="@org_id@" -->

<!-- h3>Clipboard</h3 -->
<!-- include src="/packages/lors-central/lib/clipboard" -->
</div>
<hr><h1>Preview</h1>

<if @prev_type@ eq "image"> 
    <img src="download?file_id=@file_prev_id@">
</if>
<else>
    <include src="download/preview" file_id=@file_prev_id@>
</else>

