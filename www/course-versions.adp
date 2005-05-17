<master>
<property name="title">#lorsm.lt_one_course_versions#</property>
<property name="context">@context;noquote@</property>

<listtemplate name=course_versions></listtemplate>
<br>
<if @permission_p@>
  <if @index_p@ eq 0>
    <a class="button" href="course-add?man_id=@man_id@">New Course Version</a>
  </if>
</if>