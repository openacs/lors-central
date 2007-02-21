<master>
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="displayed_object_id">@res_id@</property>
<property name="header_stuff"><style>.list-selected {font-weight:bold;font-size:120%}</style></property>
<p><a class="button" href="md/pbs-md/?ims_md_id=@displayed_object_id@">Edit Metadata</a></p>
<h3>Versions of this learning object</h3>
<listtemplate name="revisions"></listtemplate>
<include src="/packages/lors-central/lib/item-files" res_id="@res_id@" ims_item_id="@ims_item_id@">
<h3>Courses that use this learning object</h3>
<listtemplate name="courses"></listtemplate>