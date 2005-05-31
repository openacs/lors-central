<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#lors-central.dotlrn_classes#</h3>
<if @classes_list:rowcount@ gt 0>
   <listtemplate name="dotlrn_classes"></listtemplate>
   <br>
</if>
<if @drop_classes_list:rowcount@ gt 0>
   <br>
   <listtemplate name="drop_dotlrn_classes"></listtemplate>
</if>
<br>
<h3>#lors-central.dotlrn_communities#</h3>
<if @coms_list:rowcount@ gt 0>
   <br>
   <listtemplate name="coms_list"></listtemplate>
</if>

<if @coms_list_drop:rowcount@ gt 0>
   <br>
   <listtemplate name="coms_list_drop"></listtemplate>
</if>