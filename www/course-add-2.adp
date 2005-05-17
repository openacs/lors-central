<master>
<property name="context">@context;noquote@</property>

<p>  

<h2>#lorsm.lt_Preliminary_informati#</h2>
<p>


<listtemplate name="d_info"></listtemplate>
<p>
<if @isSCORM@ eq 1>
  <font color="green">#lorsm.lt_The_uploaded_file_is_# <b>#lorsm.lt_SCORM_complaint_packa#</b></font>
  <p>
</if>
<p>

<if @isSCORM@ eq 1>
<h3>#lorsm.SCORM_Package_Info#</h3>
<listtemplate name="d_SCORM_package_info"></listtemplate>
<p>
</if>


<if @isSCORM@ eq 0>
<h3>#lorsm.IMS_Package_Info#</h3>
  <if @isBB@ eq 1>
  <font color="green" size=\"-1\">  #lorsm.lt_The_uploaded_file_is_# <b>#lorsm.lt_Blackboard_6_complain#</b>.</font>
  <p>  
  </if>

<listtemplate name="d_IMS_package_info"></listtemplate>
<p>
</if>
<small><b>#lorsm.Note#</b>#lorsm._the_package_has# <b>#lorsm.not_yet#</b> #lorsm.lt_being_added_to_the_Le#


<formtemplate id=course_upload></formtemplate>




