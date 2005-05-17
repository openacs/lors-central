<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Annotation Metadata</th>
    </tr>

    <tr class="form-section">
      <td class="form-section">Entity: </td>
      <td><listtemplate name= "d_an_ent"></listtemplate></td>
    </tr>   

     <tr class="form-section">
      <td class="form-section">Date: </td>
      <td><listtemplate name= "d_an_date"></listtemplate></td>
    </tr>   

     <tr class="form-section">
      <td class="form-section">Descriptions: </td>
      <td><listtemplate name= "d_an_desc"></listtemplate></td>
    </tr>   

  </table>
