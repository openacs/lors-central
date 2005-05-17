<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<formtemplate id=upload_file></formtemplate>
<if @edit_p@ eq t>
<include src=file-content-edit>
<include src="/packages/lors-central/lib/clipboard">
</if>