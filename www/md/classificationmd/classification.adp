<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Classification Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Purpose: </td>
      <td><listtemplate name= "d_cl_pur"></listtemplate></td>
    </tr> 
    <tr class="form-section">
      <td class="form-section">Taxonomic Paths: </td>
      <td><listtemplate name= "d_cl_tpath"></listtemplate></td>
    </tr>
    <tr class="form-section">
      <td class="form-section">Descriptions: </td>
      <td><listtemplate name= "d_cl_desc"></listtemplate></td>
    </tr>
    <tr class="form-section">
      <td class="form-section">Keywords: </td>
      <td><listtemplate name= "d_cl_key"></listtemplate></td>
    </tr>	  
  </table>
