<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">#lorsm.Meta_Metadata#</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">#lorsm.Catalog-Entries# </td>
      <td><listtemplate name= "d_md_cata"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">#lorsm.Contribution# </td>
      <td><listtemplate name= "d_md_cont"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">#lorsm.Scheme# </td>
      <td><listtemplate name= "d_md_scheme"></listtemplate></td>
    </tr>   

    <tr class="form-section">
      <td class="form-section">#lorsm.Language# </td>
      <td><listtemplate name= "d_md_lang"></listtemplate></td>
    </tr>   

  </table>


