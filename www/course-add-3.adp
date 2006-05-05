<master>
<property name="context">@context;noquote@</property>

<p>  

<h2>#lorsm.lt_Preliminary_informati#</h2>
<p>

<blockquote>
<p>
<if @isSCORM@ eq 1>
  <font color="green">#lorsm.lt_The_uploaded_file_is_# <b>#lorsm.lt_SCORM_complaint_packa#</b></font>
  <p>
</if>
<small><b>#lorsm.Note#</b>#lorsm._the_package_has# <b>#lorsm.not_yet#</b> #lorsm.lt_being_added_to_the_Le#
<p>

<h2>#lorsm.Organizations#</h2>
<listtemplate name="d_orgs"></listtemplate>
<p>

<blockquote>
<h3>#lorsm.Items#</h3>
<listtemplate name="d_items"></listtemplate>
</blockquote>
<p>


<if @isSCORM@ eq 1>
<h3>#lorsm.SCOs#</h3>
<listtemplate name="d_scos"></listtemplate>
<p>

<h3>#lorsm.Assets#</h3>
<listtemplate name="d_assets"></listtemplate>
<p>
</if>


<if @isSCORM@ eq 0>
<h3>#lorsm.Resources#</h3>
<listtemplate name="d_resources"></listtemplate>
<p>
</if>
</blockquote>

<listtemplate name="d_all_files"></listtemplate>

<blockquote>
@l_files@
</blockquote>

<p>
@all_files@


