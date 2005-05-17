<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">#lorsm.General_Metadata#</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">#lorsm.Titles# </td>
      <td><listtemplate name= "d_gen_titles"></listtemplate></td>
    </tr>   

    <tr class="form-section">
     <td class="form-section">#lorsm.Catalog-Entries# </td>
     <td><listtemplate name= "d_gen_cata"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section">#lorsm.Languages# </td>
     <td><listtemplate name= "d_gen_lang"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section">#lorsm.Descriptions# </td>
     <td><listtemplate name= "d_gen_desc"></listtemplate></td>
    </tr>

    <tr class="form-section">
     <td class="form-section">#lorsm.Keywords# </td>
     <td><listtemplate name= "d_gen_key"></listtemplate></td>
    </tr>   

    <tr class="form-section">
        <td class="form-section">#lorsm.Coverage# </td>
        <td><listtemplate name= "d_gen_cover"></listtemplate></td>
    </tr>

    <tr class="form-section">
        <td class="form-section">#lorsm.Structure# </td>
        <td><listtemplate name= "d_gen_struc"></listtemplate></td>
    </tr>

    <tr class="form-section">
        <td class="form-section">#lorsm.Aggregation_Level# </td>
        <td><listtemplate name= "d_gen_aggl"></listtemplate></td>
    </tr>

  </table>

