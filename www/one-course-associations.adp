<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<br>
<h3>#lors-central.course_versions#:</h3>
<listtemplate name="course_versions"></listtemplate>

<h3>#lors-central.This_course_is#</h3>

<listtemplate name="dotlrn_classes"></listtemplate>

<br>
<if @man_id@ not nil>
    <a class=button href="course-dotlrn-assoc?man_id=@man_id;noquote@">#lors-central.associate_drop#</a>
</if>
<else>
    <a class=button href="course-dotlrn-assoc?item_id=@item_id;noquote@">#lors-central.associate_drop#</a>
</else>