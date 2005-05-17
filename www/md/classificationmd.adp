<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../lib/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Classification Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Classifications: </td>
      <td><listtemplate name= "d_cl_class"></listtemplate></td>
    </tr>   
  </table>
