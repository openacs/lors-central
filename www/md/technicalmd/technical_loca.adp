<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"
/>

<hr>

<h3>List of Technical Metadata Locations</h3>
<blockquote>
  <table cellspacing="2" cellpadding="2" border="0" width="50%">
    <tr class="form-section">
      <th colspan="2">Technical Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Locations: </td>
      <td><listtemplate name= "d_te_loca"></listtemplate></td>
    </tr>   

  </table>
</blockquote>
<p>

<h3>Add/Edit Technical Metadata Format</h3>
<blockquote>
 <formtemplate id="technicalmd_loca" style="standard-lars"></formtemplate>
</blockquote>
